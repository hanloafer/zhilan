package main;
import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;


public class SwfParser {
	
	
	public static void main(String[] args) throws FileNotFoundException, IOException {
		byte [] filebyte = new ByteArrayFilerLoader().loadFile("src/dashboard.swf");
		
		ByteArrayInputStream bi = new ByteArrayInputStream(filebyte);
		LittleEndianDataInputStream di = new LittleEndianDataInputStream(bi);
		
		//front 8 byte
		int Signature1 = di.myReadUInt(1);
		int Signature2 = di.myReadUInt(1);
		int Signature3 = di.myReadUInt(1);
		int version = di.myReadUInt(1);
		int fileLength = di.myReadInt(4);
//		fileLength = di.readInt();
		System.out.println("==========================HEAD=======================================");
		System.out.println((char)Signature1 + " " + (char)Signature2 + " " + (char)Signature3);
		System.out.println("version : " + version);
		System.out.println("file length : " + fileLength);
		
		filebyte = new ByteArrayFilerLoader().loadStream(di);
		filebyte = new ByteArrayFilerLoader().decompressBytes(filebyte);
		
		bi = new ByteArrayInputStream(filebyte);
		di = new LittleEndianDataInputStream(bi);
		
		
		
	}
}
