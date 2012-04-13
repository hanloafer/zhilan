
public class Test2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		int a = 0xffffff;
//		System.out.println(a);
//		System.out.println(Integer.toHexString(a));
//		a = a>>1;
//		System.out.println(a);
//		System.out.println(Integer.toHexString(a));
//		
//		
//		System.out.println(0x7fffffff/1024);
		
		int i,c,a,rgb;
		c = 0;
			//System.out.println(Integer.toHexString(c)); 
			a = c>>24&0xff;
			rgb = c<<8>>8&0xffffff;
			System.out.println(Integer.toHexString(a)); 
			System.out.println(Integer.toHexString(rgb)); 
			
		i = -16;
		System.out.println(Integer.toHexString(i)); 
		i = i>>8;
		System.out.println(Integer.toHexString(i)); 
	}

}
