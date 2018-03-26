package com.inswit.meoncloud.utils;

import com.inswit.meoncloud.actions.ActionDispatcher;
import com.inswit.meoncloud.constants.Constants;
import com.inswit.meoncloud.constants.RequestIds;

import com.mongodb.*;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;
import com.mongodb.util.JSON;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.bson.types.ObjectId;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Response;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.UnknownHostException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletRequest;
import javax.servlet.http.Cookie;
import org.codehaus.jettison.json.JSONString;
import org.json.simple.parser.JSONParser;

/**
 * Created with IntelliJ IDEA. User: siva Date: 8/24/16 Time: 11:28 AM To change
 * this template use File | Settings | File Templates.
 */
public class DriveUtil {

    private Logger logger = Logger.getLogger(this.getClass().getName());

    private ActionDispatcher actionDispatcher;

    public DriveUtil() {
        this.actionDispatcher = ActionDispatcher.getInstance();
    }

    private void storeFile(FileItem item, long userAid, long userZid) {

        ProcessStoreConfig processStoreConfig = actionDispatcher.getProcessStoreConfig();
        JSONObject appiyoDriveInfo = processStoreConfig.getAppiyoDriveInfo();
        boolean storeToDisk = (Boolean) appiyoDriveInfo.get("storeToDisk");

        if (storeToDisk) {
            String storageLocation = appiyoDriveInfo.get("storageLocation").toString();

            String pathStr = storageLocation + "/" + userZid + "/" + userAid;
            java.nio.file.Path path = Paths.get(pathStr);
            if (Files.notExists(path)) {
                new File(pathStr).mkdirs();
            }

            FileOutputStream fileStream = null;
            try {
                fileStream = new FileOutputStream(pathStr + "/" + item.getName());
                fileStream.write(item.get());
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (fileStream != null) {
                    try {
                        fileStream.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public Response uploadFiles(
            long aid,
            long zid,
            HttpServletRequest servletRequest,
            String id,
            String params
    ) throws ProcessStoreException {

        logger.log(Level.INFO, "File Upload request called");

        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = null;
        try {
            items = upload.parseRequest(servletRequest);
        } catch (FileUploadException e) {
            e.printStackTrace();

            JSONObject errorResponse = new JSONObject();
            String errMsg = e.getMessage();
            errorResponse.put("message", errMsg);
            logger.log(Level.SEVERE, errMsg);

            return Response.ok()
                    .status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(errorResponse.toJSONString())
                    .build();
        }

        logger.log(Level.INFO, "Number of files requested to upload :" + items.size());

        ProcessStoreConfig processStoreConfig = actionDispatcher.getProcessStoreConfig();
        JSONObject appiyoDriveInfo = processStoreConfig.getAppiyoDriveInfo();
        //  JSONObject alfrescoInfo = (JSONObject) appiyoDriveInfo.get("alfresco");
        long maxFileSize = 10000000000L;//(Long) alfrescoInfo.get("maxFileSize");
        JSONObject uploadResponse = new JSONObject();

        JSONObject requestMessage = new JSONObject();
        Iterator<FileItem> itemIterator = items.iterator();
        FileItem file = null;
        while (itemIterator.hasNext()) {

            FileItem item = itemIterator.next();
            if (item.isFormField()) {
                requestMessage.put(item.getFieldName(), item.getString());
            } else {
                if (file == null) {
                    file = item;
                    long fileSize = file.getSize();

                    logger.log(Level.INFO, "Uploading file : " + file.getName() + "  with size : " + fileSize);

                    if (fileSize > maxFileSize) {
                        long fileLimitInMB = maxFileSize / (1024 * 1024);
                        String errMsg = "File size upto " + fileLimitInMB + "MB only supported";
                        uploadResponse.put("message", errMsg);

                        logger.log(Level.SEVERE, errMsg);

                        return Response.ok()
                                .status(Response.Status.INTERNAL_SERVER_ERROR)
                                .entity(uploadResponse.toJSONString())
                                .build();
                    }
                }
            }
        }

        if (file == null) {
            String errMsg = "Invalid request, not contain any file data.";
            uploadResponse.put("message", errMsg);
            logger.log(Level.SEVERE, errMsg);

            return Response.ok()
                    .status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(uploadResponse.toJSONString())
                    .build();
        }

        String fileName = file.getName();
        String publicId = requestMessage.containsKey("publicId") ? (String) requestMessage.get("publicId") : "";
        String folder = requestMessage.containsKey("folder") ? (String) requestMessage.get("folder") : "";
        boolean overwrite = Boolean.parseBoolean((String) requestMessage.get("overwrite"));
        boolean useFileNameAsPublicId = Boolean.parseBoolean((String) requestMessage.get("useFileNameAsPublicId"));

        JSONObject metadata = null;
        if (requestMessage.containsKey("metadata")) {
            String metadataStr = (String) requestMessage.get("metadata");
            metadata = (JSONObject) Utility.getJSONObject(metadataStr);
        }
        
        

        try {

            InputStream inputStream = file.getInputStream();
            String responseMessage = uploadFileToMongo(aid, zid, "moc", inputStream, fileName,
                    file.getContentType(), publicId, folder, overwrite, useFileNameAsPublicId, metadata,id, params);

            return Response.ok()
                    .status(Response.Status.OK)
                    .entity(responseMessage)
                    .build();

        } catch (IOException e) {
            storeFile(file, aid, zid);
            String errMsg = e.getMessage();
            uploadResponse.put("message", errMsg);
            logger.log(Level.SEVERE, errMsg);

            return Response.ok()
                    .status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(uploadResponse.toJSONString())
                    .build();
        }

    }

    public String uploadFileToMongo(
            long aId,
            long zId,
            String appId,
            InputStream inputStream,
            String originalFileName,
            String contentType,
            String publicId,
            String folder,
            boolean overwrite,
            boolean useFileNameAsPublicId,
            JSONObject mediaMetadata,
            String paramId,
            String params
    ) throws ProcessStoreException, IOException {

        Mongo dbClntConn = MongoConnectionProvider.getConnection();
        DB db = dbClntConn.getDB("AppiyoFS");
        GridFS gfs = new GridFS(db);

        try {
            String fileName;
            if (!publicId.isEmpty()) {
                fileName = publicId;
                String extension = FilenameUtils.getExtension(publicId);
                if (extension.isEmpty()) {
                    fileName = fileName + FilenameUtils.getExtension(originalFileName);
                }
            } else if (useFileNameAsPublicId) {
                fileName = originalFileName;
            } else {
                fileName = FilenameUtils.removeExtension(originalFileName) + "_" + new ObjectId().toString() + "."
                        + FilenameUtils.getExtension(originalFileName);
            }

            if (!folder.isEmpty()) {
                if (folder.charAt(0) == '/') {
                    folder = folder.replaceAll("^/", "");
                }
                if (folder.charAt(folder.length() - 1) == '/') {
                    folder = folder.replaceAll("/$", "");
                }
            }

            if (!publicId.isEmpty() || useFileNameAsPublicId) {
                BasicDBObject query = new BasicDBObject();
                query.put("filename", fileName);
                query.put("metadata.aid", aId);
                query.put("metadata.appId", appId);

                if (!folder.isEmpty()) {
                    query.put("folder", folder);
                }

                GridFSDBFile file = gfs.findOne(query);
                if (file != null) {   //file exists
                    if (overwrite) {
                        Object documentId = file.get("_id");
                        DBObject condition = new BasicDBObject();
                        condition.put("_id", documentId);
                        condition.put("metadata.aid", aId);
                        condition.put("metadata.appId", appId);
                        gfs.remove(condition);
                    } else {
                        //                    dbClntConn.close();
                        throw new ProcessStoreException(
                                Constants.alfrsFileAlreadyExistsError,
                                "File with the name '" + fileName + "' already exists"
                        );
                    }
                }
            }

            GridFSInputFile file = gfs.createFile(inputStream, fileName);  //, fileData.size(), contentType,
            file.setContentType(contentType);

            DBObject metadata = new BasicDBObject();
            if (mediaMetadata != null) {
                metadata.putAll(mediaMetadata);
            }
            metadata.put("aid", aId);
            metadata.put("zid", zId);
            metadata.put("appId", appId);

            file.setMetaData(metadata);
            file.save();

            DBObject paramsMetaData = new BasicDBObject();
            paramsMetaData.put("aid", aId);
            paramsMetaData.put("zid", zId);
//            String paramId = params.get("id").toString();
            DBObject uploadParamId = new BasicDBObject();
            uploadParamId.put("id",paramId); // paramId is the id of metadata
            DBCursor cursor = db.getCollection("metaDataMapping").find(uploadParamId);
            //get params
            BasicDBObject savedData = (BasicDBObject) cursor.next();
            System.out.println("DBObject : "+savedData.toString());
            List<BasicDBObject> savedParams = (List<BasicDBObject>) savedData.get("params");
            for(int i = 0; i < savedParams.size(); i++){
                String name = savedParams.get(i).getString("keyname");
                paramsMetaData.put(name, "paramName");
            }
            
            
            
            
//          
//            
//            
//            params.put("key", params.get("key").toString());
//            params.put("variable", params.get("variable").toString());
           // paramsMetaData.put(params.get("key").toString(), params.get("variable").toString());

            DBObject appiyoMetaData = new BasicDBObject();

            if (params != null) {
                appiyoMetaData.put("appiyoMetadata", paramsMetaData);

            }

            file.setMetaData(paramsMetaData);
            file.save();

            DBObject condition = new BasicDBObject("_id", file.get("_id"));
            DBObject setOperation = new BasicDBObject();
            setOperation.put("originalFileName", originalFileName);
            setOperation.put("folder", folder);

            DBCollection collection = db.getCollection("fs.files");
            DBObject operation = new BasicDBObject("$set", setOperation);
            collection.update(condition, operation);

            db.getLastError(1, 0, true);
            //        dbClntConn.close();
            
            
                
            
            JSONObject response = (JSONObject) Utility.getJSONObject(file.toString());
            response.remove("metadata");
            
            String id = file.getId().toString();
            file.getUploadDate();

            response.put("_id", id);
            response.put("id", id);
            response.put("name", fileName);
            response.put("uploadDate",
                    DateFormatUtils.format(file.getUploadDate(), DateFormatUtils.ISO_DATETIME_FORMAT.getPattern()) + "Z");

            ProcessStoreConfig processStoreConfig = actionDispatcher.getProcessStoreConfig();
            String url = processStoreConfig.getDomain() + "/drive/docs/" + id;
            response.put("secureUrl", url);

            return response.toJSONString();
        } finally {
            dbClntConn.close();
            inputStream.close();
        }

    }

    public static void main(String args[]) throws ParseException, UnknownHostException {
        try {

//                   SimpleDateFormat fmt = new SimpleDateFormat("yyyy-mm-dd");
//                    Date from = fmt.parse("2016-09-16");
//                     Date to = fmt.parse("2016-11-1");
            String response = listDocuments(0, 0,
            null, null, null, null, null, 0, 10);
            System.out.println("response1 " + response);
            //String sampleData = "{\"name\" : \"a_account\",\"id\" : \"bank_account\", \"params\" : [ {\"id\" : \"0\",\"key\" :\"customerName\",\"variable\" : \"Shantha\"}, {\"id\" : \"1\",\"key\" : \"purpose\",\"variable\" : \"Subi\"} ]}";
            Object object = null;
            JSONObject jsonObj = null;

            JSONParser jsonParser = new JSONParser();

            //object = jsonParser.parse(sampleData);
            jsonObj = (JSONObject) object;
            JSONArray arr = new JSONArray();
            arr.add(jsonObj);
            long zid = 0L;

            //createMetaData(arr);
            //SONArray fetchUsers = fetchUsers(zid);

        } catch (MongoException e) {
            e.printStackTrace();
        } catch (org.json.simple.parser.ParseException ex) {
            Logger.getLogger(DriveUtil.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public static JSONArray fetchUsers(long zid) throws org.json.simple.parser.ParseException {
        Mongo dbClntConn = null;

        try {
            dbClntConn = MongoConnectionProvider.getConnection();
        } catch (UnknownHostException | MongoException e) {
            e.printStackTrace();
        }
        DB db = dbClntConn.getDB("AppiyoFS");
        JSONArray aidarr = new JSONArray();

        try {

            DBObject query = new BasicDBObject("metadata.zid", zid);

            JSONObject obj = new JSONObject();

            DBCursor cursor = db.getCollection("fs.files").find(query);

            while (cursor.hasNext()) {
                DBObject doc = cursor.next();
                String temp = JSON.serialize(doc);
                JSONParser parser = new JSONParser();
                JSONObject savedData = (JSONObject) parser.parse(temp);
                JSONObject metadata = (JSONObject) savedData.get("metadata");

                String tempAid = metadata.get("aid").toString();

                JSONObject aidobj = new JSONObject();
                aidobj.put("tempAid", tempAid);
                aidarr.add(aidobj);
            }

        } catch (Exception e) {
            System.out.println(e);
        }

        return aidarr;
    }

    public static JSONObject mappingRoles(JSONArray mappingConfig) throws org.json.simple.parser.ParseException {
        JSONArray mapDetails = new JSONArray();
        JSONObject aidobj = new JSONObject();
        for (int i = 0; i < mapDetails.size(); i++) {
            if (mapDetails.get(i).equals(105)) {

                Mongo dbClntConn = null;

                try {
                    dbClntConn = MongoConnectionProvider.getConnection();
                } catch (UnknownHostException | MongoException e) {
                    e.printStackTrace();
                }
                DB db = dbClntConn.getDB("AppiyoFS");
                try {

                    DBObject query = new BasicDBObject("metadata.aid", 105);

                    JSONObject obj = new JSONObject();

                    DBCursor cursor = db.getCollection("fs.files").find(query);
                    while (cursor.hasNext()) {
                        DBObject doc = cursor.next();
                        String temp = JSON.serialize(doc);
                        JSONParser parser = new JSONParser();
                        JSONObject savedData = (JSONObject) parser.parse(temp);
                        JSONObject metadata = (JSONObject) savedData.get("metadata");
                        String tempZid = metadata.get("zid").toString();

                        aidobj.put("tempAid", tempZid);
                        mapDetails.add(aidobj);
                    }
                } catch (Exception e) {
                }
            } else {

            }

        }
        return aidobj;
    }

    public static String listDocuments(
            long aId,
            long zId,
            HttpServletRequest servletRequest,
            String fileName,
            String fromDate,
            String endDate,
            String contentType,
            int index,
            int perPage
    ) throws org.json.simple.parser.ParseException {

//        JSONObject requestMessage = new  JSONObject();
//        requestMessage.put("requestId", RequestIds.AFS_LIST_FILES);
//        requestMessage.put("appId", "moc");
//        requestMessage.put("aId", aId);
//        requestMessage.put("zId", zId);
//
//
//        String responseMessage = this.actionDispatcher.processRequest(
//                "",
//                requestMessage,
//                servletRequest
//        );
//        return  responseMessage;
        Mongo dbClntConn = null;
        try {
            dbClntConn = MongoConnectionProvider.getConnection();
        } catch (UnknownHostException | MongoException e) {
            e.printStackTrace();
        }
        DB db = dbClntConn.getDB("AppiyoFS");

        DBObject query = new BasicDBObject();

        if (fileName != null && !fileName.isEmpty()) {
            DBObject fileNameQuery = new BasicDBObject();
            fileNameQuery.put("$regex", fileName);
            fileNameQuery.put("$options", "i");

            query.put("filename", fileNameQuery);
        }

//            TimeZone tz = TimeZone.getTimeZone("UTC");
//            DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
//            df.setTimeZone(tz);
//            String fromDate1 = df.format(fromDate);
//            
//            TimeZone tz1 = TimeZone.getTimeZone("UTC");
//            DateFormat df1= new SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
//            df1.setTimeZone(tz1);
//            String endDate1 = df.format(endDate);
//            String fromDate1 = "2016-09-16T13:01:32Z";
//            String endDate1 = "2016-09-16T13:01:32.222Z";
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

        if (fromDate != null && !fromDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            BasicDBObject fromDateQuery = new BasicDBObject();
            // BasicDBObject endDateQuery = new BasicDBObject();
            // queryObject.put("fromDate1", predicate);

            try {
                fromDateQuery.put("$gte", format.parse(fromDate));
                fromDateQuery.put("$lte", format.parse(endDate));
            } catch (ParseException e) {
                e.printStackTrace();
            }

//            endDateQuery.put("$lte", endDate1);
            query.put("uploadDate", fromDateQuery);
//            query.put("endDate", endDateQuery);
        }

        if (contentType != null && !contentType.isEmpty()) {
            DBObject contentTypeQuery = new BasicDBObject();
            contentTypeQuery.put("$regex", contentType);
            contentTypeQuery.put("$options", "i");

            query.put("contentType", contentTypeQuery);
        }
        if (aId != 0) {
            DBObject aIdQuery = new BasicDBObject();
            // aIdQuery.put("metadata.aid",aId);
            query.put("metadata.aid", aId);
        }

        //System.out.println("query" + query);
        DBCollection collection = db.getCollection("fs.files");

        long noOfFiles = 0;
        try {
            noOfFiles = collection.count(query);
        } catch (Exception e) {
            e.printStackTrace();
        }

        DBObject sort = new BasicDBObject();
        sort.put("uploadDate", -1);

        JSONArray files = new JSONArray();
        int i = 0;
        BasicDBObject query_aid = new BasicDBObject();

        query_aid.put("metadata.aid", aId);
        DBCursor cursor = collection.find(query);

        DBCursor cursorsort = collection.find(query);
        //.skip(index).limit(perPage).sort(sort);
        System.out.println(cursor.count());
        while (cursor.hasNext()) {
            //System.out.println(cursor.next());
            DBObject doc = cursor.next();

            String _id = ((ObjectId) doc.get("_id")).toString();
            String name = (String) doc.get("filename");
            String mimeType = (String) doc.get("contentType");
            Date date = ((Date) doc.get("uploadDate"));
            String metadata = doc.get("metadata").toString();
            JSONParser parser = new JSONParser();
            JSONObject metaJson = (JSONObject) parser.parse(metadata);
            Object aid = metaJson.get("aid");
            Long aID = (Long) aid;

            TimeZone tzz = TimeZone.getTimeZone("UTC");
            DateFormat dff = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
            dff.setTimeZone(tzz);
            String lastEdited = dff.format(date);

            JSONObject modified = new JSONObject();
//            if (aId != 0) {
//                if (aId == aID) {
//
//                    modified.put("id", _id);
//                    modified.put("name", name);
//                    modified.put("mimeType", mimeType);
//                    modified.put("lastEdited", lastEdited);
//                    modified.put("aid", aId);
//                    modified.put("index", i++);
//
//                    files.add(modified);
//                }
//                 //System.out.println("modified" + modified);
//            }
//           
//            else{

            modified.put("id", _id);
            modified.put("name", name);
            modified.put("mimeType", mimeType);
            modified.put("lastEdited", lastEdited);
            modified.put("aid", aID);
            modified.put("index", i++);
            files.add(modified);
            System.out.println("modified " + modified);
        }

        JSONObject filesJson = new JSONObject();
        filesJson.put("files", files);
        filesJson.put("noOfFiles", noOfFiles);

        JSONObject drive = new JSONObject();
        drive.put("drive", filesJson);

        JSONObject response = new JSONObject();
        response.put("status", true);
        response.put("payload", drive);

        return response.toJSONString();
    }

    public static String createMetaData(JSONObject config) throws UnknownHostException {

        JSONArray metadataParams = (JSONArray) config.get("params");

        String name = (String) config.get("name");

        Mongo dbClntConn = MongoConnectionProvider.getConnection();
        DB db = dbClntConn.getDB("AppiyoFS");
        DBCollection collection = db.getCollection("MetadataDefinition");

        BasicDBObject docToSave = new BasicDBObject();

        List<BasicDBObject> params = new ArrayList<>();

        int id = 0;

        for (int i = 0; i < metadataParams.size(); i++) {

            JSONObject obj = (JSONObject) metadataParams.get(i);
            String key = (String) obj.get("key");
            String variable = (String) obj.get("variable");

            BasicDBObject param = new BasicDBObject();

            param.put("id", id++);
            param.put("key", key);
            param.put("variable", variable);
            params.add(param);
        }

        ObjectId _id = ObjectId.get();

        docToSave.put("name", name);
        docToSave.put("id", _id.toString());
        docToSave.put("_id", _id);

        docToSave.put("params", params);

        collection.save(docToSave);

        return docToSave.toString();
    }

    public static String updateMetaData(JSONObject config) throws UnknownHostException {

        JSONArray addedParams = (JSONArray) config.get("addedParams");

        String name = (String) config.get("id");

        Mongo dbClntConn = MongoConnectionProvider.getConnection();
        DB db = dbClntConn.getDB("AppiyoFS");
        DBCollection collection = db.getCollection("MetadataDefinition");

        BasicDBObject findName = new BasicDBObject();
        findName.put("name", name);
        DBCursor findNamecursor = (DBCursor) collection.findOne(findName);

        //
        int lastParamId = 0;
        List<BasicDBObject> savedParams = (List<BasicDBObject>) config.get("params");

        HashMap<Integer, BasicDBObject> savedParamsWithId = new HashMap<Integer, BasicDBObject>();

        for (BasicDBObject savedParam : savedParams) {
            int paramId = (int) savedParam.get("id");
            if (paramId >= lastParamId) {
                lastParamId = paramId;
            }
            savedParamsWithId.put(paramId, savedParam);
        }
        lastParamId += 1;
        BasicDBObject docToSave = new BasicDBObject();

        List<BasicDBObject> params = new ArrayList<>();

        for (int i = 0; i < addedParams.size(); i++) {

            JSONObject obj = (JSONObject) addedParams.get(i);
            String key = (String) obj.get("key");
            String variable = (String) obj.get("variable");
            BasicDBObject param = new BasicDBObject();
            param.put("id", lastParamId++);
            param.put("key", key);
            param.put("variable", variable);
            params.add(param);
        }

        JSONArray updatedParams = (JSONArray) config.get("updatedParams");
        List<Integer> updatedIds = new ArrayList<Integer>();
        for (int i = 0; i < updatedParams.size(); i++) {
            JSONObject obj = (JSONObject) updatedParams.get(i);
            int id = (int) obj.get("id");
            String key = (String) obj.get("key");
            String variable = (String) obj.get("variable");
            BasicDBObject savedParam = savedParamsWithId.get(id);
            savedParam.put("key", key);
            savedParam.put("variable", variable);
            params.add(savedParam);
            updatedIds.add(id);
        }

        for (Integer id : savedParamsWithId.keySet()) {
            if (!updatedIds.contains(id)) {
                BasicDBObject savedParam = savedParamsWithId.get(id);
                params.add(savedParam);
            }
        }

        DBObject listItem = new BasicDBObject("params", savedParams);
        DBObject updateQuery = new BasicDBObject("$set", listItem);
        collection.update(findName, updateQuery);
        return docToSave.toString();
    }

    public static Object searchMetaData(Object id) throws UnknownHostException {
        BasicDBObject param = new BasicDBObject();
        Mongo dbClntConn = null;
        try {
            dbClntConn = MongoConnectionProvider.getConnection();
        } catch (UnknownHostException | MongoException e) {
            e.printStackTrace();
        }
        
            DBObject query = new BasicDBObject();

            if (id != null) {
                DBObject fileNameQuery = new BasicDBObject();
                fileNameQuery.put("$regex", id);
                fileNameQuery.put("$options", "i");

                query.put("id", fileNameQuery);

//               DBCursor cursor = collection.find(fileNameQuery);
//                List<BasicDBObject> params = new ArrayList();
//                while (cursor.hasNext()) {
//                    DBObject obj = cursor.next();
//
//                    params = (List) obj.get("params");
//                    for (int i = 0; i < params.size(); i++) {
//                        BasicDBObject iterateParams = params.get(i);
//                        String key = (String) iterateParams.get("key");
//                        String variable = (String) iterateParams.get("variable");
//                        param.put("key", key);
//                        param.put("variable", variable);
                    }

                
            
        
        return param;

    }

    private static String convertMongoDate(String val) {
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy/MM/dd");
        try {
            String finalStr = outputFormat.format(inputFormat.parse(val));
//            System.out.println(finalStr);
            return finalStr;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return "";
    }

    public Response deleteFile(
            long aId,
            long zId,
            String fileId,
            HttpServletRequest servletRequest
    ) {

        JSONObject requestMessage = new JSONObject();
        requestMessage.put("requestId", RequestIds.AFS_DELETE);
        requestMessage.put("fileId", fileId);
        requestMessage.put("aId", aId);
        requestMessage.put("zId", zId);
        requestMessage.put("appId", "moc");

        String responseMessage = this.actionDispatcher.processRequestWithoutLog(
                "",
                requestMessage,
                servletRequest
        );

        JSONObject responseMap = (JSONObject) Utility.getJSONObject(responseMessage);
        boolean status = (Boolean) responseMap.get("status");
        JSONObject payload = (JSONObject) responseMap.get("payload");

        if (status == true) {
            return Response.ok()
                    .status(Response.Status.OK)
                    .entity(payload.toJSONString())
                    .build();
        } else {

            return Response.ok()
                    .status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(payload.toJSONString())
                    .build();
        }
    }
}
