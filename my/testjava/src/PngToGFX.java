import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;

import javax.imageio.ImageIO;


public class PngToGFX implements FilenameFilter {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		PngToGFX ptg = new PngToGFX();
		File p = new File("src/dabaodaizou");
		String [] fnames = p.list(ptg);
		for (String string : fnames) {
//			System.out.println(p.getAbsolutePath());
			File png = new  File(p.getAbsolutePath() + "\\" + string);
//			System.out.println(png.getAbsolutePath());
			ptg.pngCutAlphaRect(png);
//			break;
		}
//		int t = 0xffffffff;
//		t = t>> 24;
//		System.out.println(t);
//		t = t & 0xff; 
//		System.out.println(Integer.toHexString(t));
//		System.out.println(t);
	}
	
	private BufferedImage imgCutAlphaRect(BufferedImage img){
		int w = img.getWidth();
		int h = img.getHeight();
		int top=-1, bottom=-1, left=-1, right=-1;
//		int minRX, maxLX = w, minBY, maxTY = h;
		int x, y;
		//shang
		System.out.println(w + "!" + h);
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
		System.out.println("t c");
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
		System.out.println("b c");
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
		System.out.println("l c");
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
		//int [] rgbArray  = new int[newW * newH]; 
		//img.getRGB(left, top, newW, newH, rgbArray, 0, newW);
		int [] rgbArray  = new int[img.getWidth() * img.getHeight()]; 
		
		img.getRGB(0, 0, img.getWidth(), img.getHeight(), rgbArray, 0, img.getWidth());
		
		BufferedImage newimg = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_INT_RGB );
		//newimg.setRGB(0, 0, newW, newH, rgbArray, 0, newW);
		newimg.setRGB(0, 0, img.getWidth(), img.getHeight(), rgbArray, 0, img.getWidth());
		return newimg;
	}
	
	
	
	private BufferedImage mergeBitmapData(BufferedImage [] bitmapDatas){
		int w = 0,h = 0;
		for(int i=0; i<bitmapDatas.length; i++){
			BufferedImage tmp = bitmapDatas[i];
			w += tmp.getWidth();
			if(tmp.getHeight() > h){
				h = tmp.getHeight();
			}
		}
		int offsetX = 0;
		BufferedImage newimg = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
		for(int i=0; i<bitmapDatas.length; i++){
			BufferedImage tmp = bitmapDatas[i];
			int [] rgbArray = tmp.getRGB(0, 0, tmp.getWidth(), tmp.getHeight(), null, 0, tmp.getWidth());
			newimg.setRGB(offsetX, 0, tmp.getWidth(), tmp.getHeight(), rgbArray, 0, tmp.getWidth());
			
			offsetX += tmp.getWidth();
		}
		return newimg;
	}
	
	private void pngCutAlphaRect(File png){
		BufferedImage img = null;
		try {
			img = ImageIO.read(png);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		BufferedImage newimg = imgCutAlphaRect(img);
		try {
			ImageIO.write(newimg, "png", new File("src/cut/" + png.getName()));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//xia 
		//zuo 
		//you
		
//		int [] bitmapData = img.getRGB(0, 0);
	}

	@Override
	public boolean accept(File dir, String name) {
		if(name.endsWith(".png")){
			return true;
		}else{
			return false;
		}
	}

}
