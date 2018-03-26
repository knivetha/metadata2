/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.Random;



/**
 *
 * @author Nivetha
 */

public class randomGenerate {

    int id;
    Random rnd = new Random();


    
    public String generateID(String table) {
        char[] chars = "0123456789".toCharArray();
        StringBuilder sb = new StringBuilder((100000 + rnd.nextInt(900000)) + "0");
        for (int i = 0; i < 2; i++) {
            sb.append(chars[rnd.nextInt(chars.length)]);
        }
        sb.append(table);
        return sb.toString();
    }
      public String generateAccesstoken(String table) {
        char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();
        StringBuilder sb = new StringBuilder((100000 + rnd.nextInt(900000)) + "Z");
       
        for (int i = 0; i < 9; i++) {
            sb.append(chars[rnd.nextInt(chars.length)]);
        }
        return sb.toString();
    }//return string
}