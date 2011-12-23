package main;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.Deflater;
import java.util.zip.Inflater;


public class ByteArrayFilerLoader {
	
	public byte [] loadFile(String url) throws FileNotFoundException, IOException{
		FileInputStream fis = new FileInputStream(new File(url));
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
		return bytearray1;
	}
	
	public byte [] loadStream(InputStream is) throws FileNotFoundException, IOException{
		int len = 0;
		byte [] buffer = new byte[1024];
		byte [] bytearray1 = new byte[0];
		while((len = is.read(buffer))> 0){
			byte [] temp = new byte[bytearray1.length + len];
			System.arraycopy(bytearray1, 0, temp, 0, bytearray1.length);
			System.arraycopy(buffer, 0, temp, bytearray1.length, len);
			bytearray1 = temp;
		}
		return bytearray1;
	}
	
	public byte [] loadByte(byte [] bytearray) throws FileNotFoundException, IOException{
		ByteArrayInputStream bi = new ByteArrayInputStream(bytearray);
		int len = 0;
//		ArrayList bytearray = new ArrayList();
		byte [] buffer = new byte[1024];
		byte [] bytearray1 = new byte[0];
		while((len = bi.read(buffer))> 0){
			byte [] temp = new byte[bytearray1.length + len];
			System.arraycopy(bytearray1, 0, temp, 0, bytearray1.length);
			System.arraycopy(buffer, 0, temp, bytearray1.length, len);
			bytearray1 = temp;
		}
		return bytearray1;
	}
	
	private static int cachesize = 1024; 
	private  Inflater decompresser = new Inflater(); 
	private  Deflater compresser = new Deflater(); 
	
	public byte[] decompressBytes(byte input[]) 
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
