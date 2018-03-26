/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



import com.mongodb.DB;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.MongoURI;

import java.net.UnknownHostException;

/**
 * Created with IntelliJ IDEA.
 * User: siva
 * Date: 10/7/16
 * Time: 5:54 PM
 * To change this template use File | Settings | File Templates.
 */
public class connectionDb {

//    private static String host = "localhost";
//    private static int port = 27017;

    private static String uri = null;

    private connectionDb(){

    }

    private static String getMongoUri(){
//        if(uri == null){
//            ProcessStoreConfig processStoreConfig = ActionDispatcher.getInstance().getProcessStoreConfig();
//            JSONObject dbConfig = processStoreConfig.getDbConfig();
//            uri = dbConfig.get("url").toString();
//        }
    	uri = "127.0.0.1:27017";
      //  uri="localhost:27017";
        return uri;
    }

    public static Mongo getConnection() throws UnknownHostException, MongoException {
        Mongo connection = null;
//        try {
            String uriStr = getMongoUri();
            if(uriStr.startsWith(MongoURI.MONGODB_PREFIX)){
                MongoURI mongoURI = new MongoURI(uriStr);
                connection = new Mongo(mongoURI);
            }else{
                connection = new Mongo(uriStr);
            }

//        } catch (MongoException e) {
//            e.printStackTrace();
//        } catch (UnknownHostException e) {
//            e.printStackTrace();
//        }

        return connection;
    }
}

    

