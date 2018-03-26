/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Nivetha**/
import com.mongodb.BasicDBObject;
import com.mongodb.BasicDBObjectBuilder;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.gridfs.GridFS;
import com.mongodb.util.JSON;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


public class createData {
    
    public static void main(String args[]) throws UnknownHostException{
    //connection code
    try{
        String name="";
        int id=0;
        String key="";
     Mongo mongo = new Mongo("localhost", 27017);
	DB db = mongo.getDB("meta_Data");

	DBCollection collection = db.getCollection("create_metadata");

	// 1. BasicDBObject example
	System.out.println("BasicDBObject example...");
	BasicDBObject document = new BasicDBObject();
	document.put("name",name);
	

	BasicDBObject documentDetail = new BasicDBObject();
	documentDetail.put("id", id);
	
	documentDetail.put("key", key);
	document.put("field", documentDetail);

	collection.insert(document);
        mongo.close();
	

	


    } catch (MongoException e) {
	e.printStackTrace();
    }
    }
  
}
    //close the connection with the mongodb

