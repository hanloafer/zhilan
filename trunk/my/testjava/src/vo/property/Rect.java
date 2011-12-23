package vo.property;

import main.LittleEndianDataInputStream;


//Nbits UB[5] 	 Bits in each rect value field
//Xmin SB[Nbits] x minimum position for rect
//Xmax SB[Nbits] x maximum position for rect
//Ymin SB[Nbits] y minimum position for rect
//Ymax SB[Nbits] y maximum position for rect
public class Rect {
	public int Nbits;
	public int Xmin;
	public int Xmax;
	public int Ymin;
	public int Ymax;
	
	public static Rect parse(LittleEndianDataInputStream di){
		Rect ret = new Rect();
//		ret.Nbits = di.myReadUInt(btyeNum)
		return null;
	}
}
