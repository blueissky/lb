
public class t {
	public static void main(String[] args) {
		
		for(int i=1;i<=3;i++) {
			for(int j=1;j<=3;j++) {
				String str="$(\"#road_"+i+"_"+j+"\").val();";
				System.out.println(str);
			}
		}
		
		
	}
}
