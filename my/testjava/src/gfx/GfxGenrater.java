package gfx;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;


public class GfxGenrater {
	
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
		img.getRGB(left, top, newW, newH, rgbArray, 0, newW);
//		int [] rgbArray  = new int[img.getWidth() * img.getHeight()]; 
		
		//img.getRGB(0, 0, img.getWidth(), img.getHeight(), rgbArray, 0, img.getWidth());
		
		BufferedImage newimg = new BufferedImage(newW, newH, BufferedImage.TYPE_INT_ARGB );
		newimg.setRGB(0, 0, newW, newH, rgbArray, 0, newW);
		//newimg.setRGB(0, 0, img.getWidth(), img.getHeight(), rgbArray, 0, img.getWidth());
		
		FrameInfo frameInfo = new FrameInfo();
		frameInfo.frameBitMap = newimg;
		frameInfo.offsetX = left;
		frameInfo.offsetY = top;
		
		return frameInfo;
	}
	
	
	
	public BufferedImage mergeBitmapData(FrameInfo [] bitmapDatas){
		int w = 0,h = 0;
		for(int i=0; i<bitmapDatas.length; i++){
			BufferedImage tmp = bitmapDatas[i].frameBitMap;
			w += tmp.getWidth();
			if(tmp.getHeight() > h){
				h = tmp.getHeight();
			}
		}
		int offsetX = 0;
		BufferedImage newimg = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB );
		for(int i=0; i<bitmapDatas.length; i++){
			BufferedImage tmp = bitmapDatas[i].frameBitMap;
			int [] rgbArray = tmp.getRGB(0, 0, tmp.getWidth(), tmp.getHeight(), null, 0, tmp.getWidth());
			newimg.setRGB(offsetX, 0, tmp.getWidth(), tmp.getHeight(), rgbArray, 0, tmp.getWidth());
			
			offsetX += tmp.getWidth();
		}
		return newimg;
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
