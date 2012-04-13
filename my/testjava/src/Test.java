import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Field;

import javax.imageio.ImageIO;

import main.LittleEndianDataInputStream;


public class Test {
	
	public static void main(String[] args) throws IOException, IllegalArgumentException, IllegalAccessException {
		byte [] a =  {-42};
		ByteArrayInputStream bi = new ByteArrayInputStream(a);
		LittleEndianDataInputStream di = new LittleEndianDataInputStream(bi);
		
//		System.out.println(di.read());
		
		byte b = -1;
		int c = b & 0xff;
		System.out.println(Integer.toBinaryString(b));
		System.out.println(Integer.toBinaryString(0xff));
		System.out.println(c);
		String s [] = ImageIO.getReaderFormatNames();
		System.out.println();
		for(String i : s){
			System.out.println(i);
		}
		System.out.println();
		s = ImageIO.getReaderMIMETypes();
		for(String i : s){
			System.out.println(i);
		}
		BufferedImage bbi = new BufferedImage(1, 1, BufferedImage.TYPE_3BYTE_BGR);
		try {
			Class cla = Class.forName("java.awt.image.BufferedImage");
			Field fs[] = cla.getDeclaredFields();
			for(Field f : fs){
				try {
					System.out.println(f.getName() + ":" + f.get(bbi));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
	}
}
