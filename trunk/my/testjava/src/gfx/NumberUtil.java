package gfx;

public class NumberUtil {

	public static String to3String(int i){
		String ret = "";
		if(i>=100){
			i = i/100;
		}
		ret+=((int)i/100) % 10;
		ret+=((int)i/10) % 10;
		ret+=i % 10;
		return ret;
	}
}
