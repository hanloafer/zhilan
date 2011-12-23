package main;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;


public class LittleEndianDataInputStream extends DataInputStream {

	public LittleEndianDataInputStream(InputStream in) {
		super(in);
		// TODO Auto-generated constructor stub
	}
	
	public final short myReadShort() throws IOException {
        int ch1 = in.read();
        int ch2 = in.read();
        if ((ch1 | ch2) < 0)
            throw new EOFException();
        return (short)((ch2 << 8) + (ch1 << 0));
    }
	
	//32
	public final int myReadInt() throws IOException {
        int ch1 = in.read();
        int ch2 = in.read();
        int ch3 = in.read();
        int ch4 = in.read();
        if ((ch1 | ch2 | ch3 | ch4) < 0)
            throw new EOFException();
        return ((ch4 << 24) + (ch3 << 16) + (ch2 << 8) + (ch1 << 0));
    }
	
	public final int myReadInt8() throws IOException{
		return readByte();
	}
	
	public final int myReadInt(int btyeNum)throws IOException{
		if(btyeNum < 0){
			throw new EOFException("btyeNum invalidete");
		}
		
		int val = 0;
		int ret = 0;
		for (int i = 0; i < btyeNum; i++) {
			int ch = in.read();
			val |= ch;
			ret += ch << 8*i;
		}
		if(val < 0){
			 throw new EOFException();
		}
		
		return ret;
	}
	
//	public final int myReadUIntBit(int btyeNum)throws IOException{
//		
//	}
	
	public final int myReadUInt(int btyeNum)throws IOException{
		if(btyeNum < 0){
			throw new EOFException("btyeNum invalidete");
		}
		
		int val = 0;
		int ret = 0;
		int fix = 0;
		for (int i = 0; i < btyeNum; i++) {
			int ch = in.read();
			val |= ch;
			ret += (ch << 8*i);
			fix = fix << 8;
			fix += 0xff;
		}
		if(val < 0){
			 throw new EOFException();
		}
		
		return ret & fix;
	}
	

}
