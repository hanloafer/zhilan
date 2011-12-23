import java.io.ByteArrayInputStream;
import java.io.IOException;

import main.LittleEndianDataInputStream;


public class Test {
	
	public static void main(String[] args) throws IOException {
		byte [] a =  {-42};
		ByteArrayInputStream bi = new ByteArrayInputStream(a);
		LittleEndianDataInputStream di = new LittleEndianDataInputStream(bi);
		
//		System.out.println(di.read());
		
		byte b = -1;
		int c = b & 0xff;
		System.out.println(Integer.toBinaryString(b));
		System.out.println(Integer.toBinaryString(0xff));
		System.out.println(c);
	}
}
