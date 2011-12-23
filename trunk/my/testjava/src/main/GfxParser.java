package main;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

import javax.imageio.ImageIO;


public class GfxParser {
	
	public final static int TAG_DATA		 = 0;
	public final static int TAG_JPG		 = 1;
	public final static int TAG_ALPHA		 = 2;
	public final static int TAG_TBE		 = 3;
	public final static int TAG_PNGPALETTE	 = 4;		//索引色PNG

	/**
	 * @param args
	 * 
	 * 
	 * var bytearr:ByteArray = new ByteArray;
			bytearr.length = inbytearr.length;
			bytearr.writeBytes(inbytearr,0,inbytearr.length);
			
			bytearr.position=0;
			bytearr.uncompress();
			
			bytearr.endian = Endian.LITTLE_ENDIAN;
			while(bytearr.bytesAvailable)
			{
				var type:int = bytearr.readShort();//16
				var len:int = bytearr.readUnsignedInt();//32
//				trace(type,len);
				
				var bufferByte:ByteArray = new ByteArray();
				bufferByte.length = len;
				bytearr.readBytes(bufferByte,0,bufferByte.length);
				
				switch(type)
				{
					case TAG_PNGPALETTE:
					{
						bufferByte.position=0;
						rgb = new ImageLoader(bufferByte,lc);
						rgb.addEventListener(Event.COMPLETE,onRgbComplete);
						rgb.loadBytes(bufferByte,lc);
						bHasRGB = true;
					}break;
					case TAG_JPG:
					{
						bufferByte.position=0;
						rgb = new ImageLoader();
						rgb.addEventListener(Event.COMPLETE,onRgbComplete);
						rgb.loadBytes(bufferByte,lc);
						bHasRGB = true;
		
					}break;
					case TAG_ALPHA:
					{
						bufferByte.position=0;
						//opque= new ImageLoader(bufferByte,lc);
						opque= new ImageLoader();
						opque.addEventListener(Event.COMPLETE,onAlphaComplete);
						opque.loadBytes(bufferByte,lc);
						bHasALPHA = true;
					}break;
					case TAG_TBE:
					{
						bufferByte.position = 0;
						bufferByte.uncompress();
						TbeData = bufferByte;
						LoadTbeBinary(bufferByte);
						
						TbeData.endian = Endian.LITTLE_ENDIAN;
						bTbe = true;
						bHasTBE = true;
					}break;
				}
			}
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
//		FileReader reader = new FileReader("000001008.gfx");
//		byte []  bytearray = new byte[10000000];
//		BufferedReader br = new BufferedReader(new FileReader(new File("/000001008.gfx")));
		
		FileInputStream fis = new FileInputStream(new File("src/000001008.gfx"));
		int len = 0;
//		ArrayList bytearray = new ArrayList();
		byte [] buffer = new byte[1024];
		byte [] bytearray1 = new byte[0];
		while((len = fis.read(buffer))> 0){
			byte [] temp = new byte[bytearray1.length + len];
			System.arraycopy(bytearray1, 0, temp, 0, bytearray1.length);
			System.arraycopy(buffer, 0, temp, bytearray1.length, len);
			bytearray1 = temp;
		}
		bytearray1 = decompressBytes(bytearray1);
		
		ByteArrayInputStream bi = new ByteArrayInputStream(bytearray1);
	
		LittleEndianDataInputStream di = new LittleEndianDataInputStream(bi);
		
		while(true){
			
			int type = di.myReadShort();
			int bytelen = di.myReadInt();
			
			
			boolean isok = false;
			switch(type)
			{
				case TAG_PNGPALETTE:
				
	//				bufferByte.position=0;
	//				rgb = new ImageLoader(bufferByte,lc);
	//				rgb.addEventListener(Event.COMPLETE,onRgbComplete);
	//				rgb.loadBytes(bufferByte,lc);
	//				bHasRGB = true;
					throw new Exception("png");
				case TAG_JPG:
				{
					byte [] jpgbyte = new byte[bytelen];
					di.read(jpgbyte, 0, bytelen);
					BufferedImage jpcimg = ImageIO.read(new ByteArrayInputStream(jpgbyte));
					ImageIO.write(jpcimg, "jpg", new File("src/jpg.jpg"));
	//				bufferByte.position=0;
	//				rgb = new ImageLoader();
	//				rgb.addEventListener(Event.COMPLETE,onRgbComplete);
	//				rgb.loadBytes(bufferByte,lc);
	//				bHasRGB = true;
	
				}break;
				case TAG_ALPHA:
				{
					byte [] jpgbyte = new byte[bytelen];
					di.read(jpgbyte, 0, bytelen);
					BufferedImage jpcimg = ImageIO.read(new ByteArrayInputStream(jpgbyte));
					ImageIO.write(jpcimg, "jpg", new File("src/jpg_alpha.jpg"));
					
					ArrayList<Integer> colors = new ArrayList<Integer>();
					HashMap<Integer, Integer> cs = new HashMap<Integer, Integer>();
					int w = jpcimg.getWidth();
					int h = jpcimg.getHeight();
					for(int i=0; i<w; i++){
						for(int j=0; j<h; j++){
							int a = jpcimg.getRGB(i, j);
							if(!colors.contains(a)){
								colors.add(a);
							}
							if(!cs.containsKey(a)){
								cs.put(a, 0);
							}
							int num = cs.get(a);
							num++;
							cs.remove(a);
							cs.put(a, num);
						}
					}
					Set<Integer> cos = cs.keySet();
					for (Integer integer : cos) {
						System.out.println(Integer.toHexString(integer) + "   " + cs.get(integer));
					}
//					for (int i = 0; i < cos.size(); i++) {
//						Integer co = cos.
//						System.out.println(Integer.toHexString(co));
//					}
				}break;
				case TAG_TBE:
				{
	//				bufferByte.position = 0;
	//				bufferByte.uncompress();
	//				TbeData = bufferByte;
	//				LoadTbeBinary(bufferByte);
	//				
	//				TbeData.endian = Endian.LITTLE_ENDIAN;
	//				bTbe = true;
	//				bHasTBE = true;
					isok = true;
				}break;
				
			}
			if(isok){
				break;
			}
		}
		
	}
	
	private static int cachesize = 1024; 
	private static Inflater decompresser = new Inflater(); 
	private static Deflater compresser = new Deflater(); 
	
	public static byte[] decompressBytes(byte input[]) 
	{ 
		byte output[] = new byte[0]; 
		decompresser.reset(); 
		decompresser.setInput(input); 
		ByteArrayOutputStream o = new ByteArrayOutputStream(input.length); 
		try 
		{ 
			byte[] buf = new byte[cachesize];
	
			int got; 
			while (!decompresser.finished()) 
			{ 
				got = decompresser.inflate(buf); 
				o.write(buf, 0, got); 
			} 
			output = o.toByteArray(); 
		}
		catch(Exception e) 
		{ 
			e.printStackTrace(); 
		}finally { 
			try 
			{ 
				o.close(); 
			} catch (IOException e) 
			{ 
				e.printStackTrace(); 
			} 
		} 
		return output; 
	} 
}



