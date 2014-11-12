package aca.util;

public class RandomString {

	
	public static String getRandomString(){
        String alphaNum="1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        StringBuffer sbRan = new StringBuffer(11);
        int num;
        for(int i = 0; i < 11; i++){
          num = (int)(Math.random()* (alphaNum.length() - 1));
          sbRan.append(alphaNum.substring(num, num+1));
        }
        return sbRan.toString();
   }
	
}
