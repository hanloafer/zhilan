package gfx;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;


public class GfxGenrater {
	
	public  static final int TAG_DATA		 = 0;
	public  static final int TAG_JPG		 = 1;
	public  static final int TAG_ALPHA		 = 2;
	public  static final int TAG_TBE		 = 3;
	public  static final int TAG_PNGPALETTE	 = 4;		//索引色PNG
	
	public FrameInfo [] imgsCutAlphaRect(BufferedImage [] imgs){
		FrameInfo [] cutImgs = new FrameInfo[imgs.length];
		for(int i=0; i<imgs.length; i++){
			cutImgs[i] = imgCutAlphaRect(imgs[i]);
		}
		return cutImgs;
	}

	private FrameInfo imgCutAlphaRect(BufferedImage img){
		int w = img.getWidth();
		int h = img.getHeight();
		int top=-1, bottom=-1, left=-1, right=-1;
//		int minRX, maxLX = w, minBY, maxTY = h;
		int x, y;
		//shang
		//System.out.println(w + "!" + h);
		for(y=0; y<h; y++){
			for(x=0; x<w; x++){
				int c = img.getRGB(x, y);
				c = c >> 24;
				c &= 0xff;
				if(c > 0){
					top = y;
					break;
				}
//				System.out.println(Integer.toHexString(c));
			}
			if(top > -1){
				break;
			}
		}
		//System.out.println("t c");
		for(y=h-1; y>-1; y--){
			for(x=0; x<w; x++){
				int c = img.getRGB(x, y);
				c = c >> 24;
				c &= 0xff;
				if(c > 0){
					bottom = y;
					break;
				}
			}
			if(bottom > -1){
				break;
			}
		}
		//System.out.println("b c");
		for(x=0; x<w; x++){
			for(y=top; y<bottom; y++){
				int c = img.getRGB(x, y);
				c = c >> 24;
				c &= 0xff;
				if(c > 0){
					left = x;
					break;
				}
			}
			if(left > -1){
				break;
			}
		}
		//System.out.println("l c");
		for(x=w-1; x> -1; x--){
			for(y=top; y<bottom; y++){
				int c = img.getRGB(x, y);
				c = c >> 24;
				c &= 0xff;
				if(c > 0){
					right = x;
					break;
				}
			}
			if(right > -1){
				break;
			}
		}
		int newW = right - left + 1;
		int newH = bottom - top + 1;
		int [] rgbArray  = new int[newW * newH]; 
		if(left < 0){
			left =0;
		}
		if(top<0){
			top = 0;
		}
		img.getRGB(left, top, newW, newH, rgbArray, 0, newW);
//		int [] rgbArray  = new int[img.getWidth() * img.getHeight()]; 
		
		//img.getRGB(0, 0, img.getWidth(), img.getHeight(), rgbArray, 0, img.getWidth());
		
		BufferedImage newimg = new BufferedImage(newW, newH, BufferedImage.TYPE_4BYTE_ABGR );
		newimg.setRGB(0, 0, newW, newH, rgbArray, 0, newW);
		//newimg.setRGB(0, 0, img.getWidth(), img.getHeight(), rgbArray, 0, img.getWidth());
		
		FrameInfo frameInfo = new FrameInfo();
		frameInfo.frameBitMap = newimg;
		frameInfo.offsetX = left;
		frameInfo.offsetY = top;
		
		return frameInfo;
	}
	
	
	
	public BufferedImage mergeBitmapData(FrameInfo [] frameInfos){
		int w = 0,h = 0;
		for(int i=0; i<frameInfos.length; i++){
			BufferedImage tmp = frameInfos[i].frameBitMap;
			w += tmp.getWidth();
			if(tmp.getHeight() > h){
				h = tmp.getHeight();
			}
		}
		int offsetX = 0;
		BufferedImage newimg = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB );
		for(int i=0; i<frameInfos.length; i++){
			BufferedImage tmp = frameInfos[i].frameBitMap;
			int [] rgbArray = tmp.getRGB(0, 0, tmp.getWidth(), tmp.getHeight(), null, 0, tmp.getWidth());
			newimg.setRGB(offsetX, 0, tmp.getWidth(), tmp.getHeight(), rgbArray, 0, tmp.getWidth());
			
			frameInfos[i].x = offsetX;
			frameInfos[i].y = 0;
			frameInfos[i].width = frameInfos[i].frameBitMap.getWidth();
			frameInfos[i].height = frameInfos[i].frameBitMap.getHeight();
			offsetX += tmp.getWidth();
		}
		return newimg;
	}
	
	public byte [] genarateGfx(FrameInfo [] bitmapDatas) throws IOException{
		BufferedImage png = mergeBitmapData(bitmapDatas);
		int w = png.getWidth();
		int h = png.getHeight();
		int [] argbArray = png.getRGB(0, 0, png.getWidth(), png.getHeight(), null, 0, png.getWidth());
		int [] aArray = new int[argbArray.length];
		int [] rgbArray = new int[argbArray.length];
		
		BufferedImage ajpg = new  BufferedImage(png.getWidth(), png.getHeight(), BufferedImage.TYPE_INT_BGR );
		BufferedImage rgbjpg = new  BufferedImage(png.getWidth(), png.getHeight(), BufferedImage.TYPE_INT_BGR );
		
		int i,c,a,rgb,tp;
		for(i = 0; i<argbArray.length; i++){
			c = argbArray[i];
			//System.out.println(Integer.toHexString(c)); 
			tp = c>>24&0xff;
			a = tp + (tp<<8) + (tp<<16);
			rgb = c<<8>>8&0xffffff;
//			if(a < 0 || rgb< 0){
//				//System.out.println("error");
//			}//System.out.println(Integer.toHexString(a) + " : " + Integer.toHexString(rgb));
			aArray[i] = a;
			rgbArray[i] = rgb;
		}
		ajpg.setRGB(0, 0, w, h, aArray, 0, w);
		rgbjpg.setRGB(0, 0, w, h, rgbArray, 0, w);
		
		ByteArrayOutputStream finalbaos = new ByteArrayOutputStream();
		DataOutputStream  finaldos =  new DataOutputStream(finalbaos);
		
		ByteArrayOutputStream tbebytedos = new ByteArrayOutputStream();
		DataOutputStream  tbedos =  new DataOutputStream(tbebytedos);
		tbedos.writeShort(400);
		tbedos.writeShort(400);
		tbedos.writeShort(bitmapDatas.length);
		for(i =0; i<bitmapDatas.length; i++){
//			tmpFrmInfo.iFrame = content.readShort();
//			tmpFrmInfo.iOffsetX = content.readShort();
//			tmpFrmInfo.iOffsetY = content.readShort();
//			tmpFrmInfo.nRawWidth =0;//= content.readByte();
//			tmpFrmInfo.nRawHeight = content.readShort();
//			
//			tmpFrmInfo.left		= content.readShort();
//			tmpFrmInfo.top 		= content.readShort();
//			tmpFrmInfo.right 	= content.readShort();
//			tmpFrmInfo.bottom	= content.readShort();
			FrameInfo fi = bitmapDatas[i];
			tbedos.writeShort(i);
			tbedos.writeShort(fi.offsetX);
			tbedos.writeShort(fi.offsetY);
			
			tbedos.writeShort(fi.x);
			tbedos.writeShort(fi.y);
			tbedos.writeShort(fi.width);
			tbedos.writeShort(fi.height);
		}
		tbedos.close();
		
		byte tbebyte [] = ZLibUtils.compress(tbebytedos.toByteArray());
		
		
		ByteArrayOutputStream alphaos = new ByteArrayOutputStream();
		ImageIO.write(ajpg, "jpg", alphaos);
		alphaos.close();
		ByteArrayOutputStream rgbos = new ByteArrayOutputStream();
		ImageIO.write(rgbjpg, "jpg", rgbos);
		rgbos.close();
		
		//test
		FileOutputStream os = new FileOutputStream(new File("alpha.jpg"));
		ImageIO.write(ajpg, "jpg", os);
		os.close();
//		os = new FileOutputStream(new File("rgb.jpg"));
//		ImageIO.write(rgbjpg, "jpg", os);
//		os.close();
		
		genaratePart(finaldos, tbebyte, TAG_TBE);
		genaratePart(finaldos, alphaos.toByteArray(), TAG_ALPHA);
		genaratePart(finaldos, rgbos.toByteArray(), TAG_JPG);
		finaldos.close();
		
		byte ret [] = ZLibUtils.compress(finalbaos.toByteArray());
		
		return ret;
	}
	
	private void genaratePart(DataOutputStream  dos, byte [] body, int type) throws IOException{
		dos.writeShort(type);
		dos.writeInt(body.length);
		dos.write(body, 0, body.length);
	}
	
	private BufferedImage pngCutAlphaRect(File png){
		BufferedImage img = null;
		try {
			img = ImageIO.read(png);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		BufferedImage newimg = null;//imgCutAlphaRect(img);
		try {
			ImageIO.write(newimg, "png", new File("src/cut/" + png.getName()));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return newimg;
		//xia 
		//zuo 
		//you
		
//		int [] bitmapData = img.getRGB(0, 0);
	}
	
}
