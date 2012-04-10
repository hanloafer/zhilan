
public class TestCastArray {
	 public static void main(String[] args) {
	        Object[] a = new Object[] {"1", "2"};
	        String[] array;
	        array = (String[])a;
	        for(String s : array) {
	            System.out.println(s);
	        }
	    }
}
