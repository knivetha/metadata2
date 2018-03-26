/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Nivetha
 */
@WebServlet(urlPatterns = {"/login"})
public class login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
         Mongo dbClntConn = connectionDb.getConnection();
         DB db = dbClntConn.getDB("AppiyoFS");
         randomGenerate generate=new randomGenerate();
        PrintWriter out = response.getWriter();
        
        try {
             String login = null;
            String signUp = null, logout = null;
            Integer aId=0;
            login = request.getParameter("login");
            signUp = request.getParameter("signUp");
            logout = request.getParameter("logout");
            
          
   
             if (login != null) {
                 
                String loginEmail = request.getParameter("email");
                String loginPwd = request.getParameter("password");
                String loginType = request.getParameter("loginType");
                 
                String temp=null;
                String zid=null;
                Long aid=0L;
                String userLoginID = "null", userName = null,authToken=null;
                 
                 
                DBCollection collection = db.getCollection("userDetails");
                BasicDBObject search = new BasicDBObject();
                search.put("loginEmail", loginEmail);
                search.put("loginPassword", loginPwd);
                search.put("roles",loginType);
//                
                DBCursor cursor = collection.find(search);
                //out.print(cursor);
              
                while (cursor.hasNext()) {
//                   
                    DBObject obj = cursor.next();
                  
                    userLoginID = (String) obj.get("userLoginID");
                    userName = (String) obj.get("loginEmail");
                    loginType =(String)obj.get("roles");
                    out.println(loginType+"lOgintype");
                    BasicDBObject metadata = (BasicDBObject)obj.get("metadata");
                    temp = metadata.getString("aid");
                    zid = metadata.getString("zid");
                    
                   
                }
                 
                request.setAttribute("aid", temp);
                request.setAttribute("zid", zid);
                
//                
                if (userLoginID != null && userName != null) {
                    Object insert = generate.generateAccesstoken(authToken);
                    Cookie cookie = new Cookie("LogedInuserName", userName);
                    
                    Cookie cookie1 = new Cookie("authToken1", (String) insert);
                    cookie1.setPath("/MeOnCloud");
                    response.addCookie(cookie);
                    response.addCookie(cookie1);
                    String insert1=(String) insert;
                    
                    DBCollection usersLogedIn = db.getCollection("loggedInUserDetails");
                    BasicDBObject insertUser = new BasicDBObject();
                    insertUser.put("usersLogesInID", generate.generateID("UsersLogedInID"));
                    insertUser.put("userLoginID", userLoginID);
                    insertUser.put("userName", userName);
                    insertUser.put("authToken",insert);
                    insertUser.put("aid",temp);
                    insertUser.put("zid",zid);
                    insertUser.put("roles",loginType);
                        
                    usersLogedIn.insert(insertUser);
                    
                    request.setAttribute("userLoginID", userLoginID);
                    request.setAttribute("userName", userName);
                    request.setAttribute("authToken", insert);
                    request.setAttribute("roles",loginType);
                    BasicDBObject searchd = new BasicDBObject();
                    searchd.put("userLoginID", userLoginID);
                    searchd.put("userName", userName);
                    searchd.put("authToken",insert);
                   
                    
                    
                    
                    DBCursor cursord = collection.find(searchd);
                    //out.print(cursord);
                    while (cursord.hasNext()) {
                        out.print("inside while");
                        DBObject objd = cursord.next();
                       
//                        appDetailsID = (String) objd.get("appDetailsID");
//                        appName = (String) objd.get("appName");
//                        clientID = (String) objd.get("clientID");
                    }

                    RequestDispatcher rsd = request.getRequestDispatcher("home.jsp");
                    rsd.forward(request, response);
                } else {
                    request.setAttribute("status", " Login failed .Please check your credentials");
                    RequestDispatcher rsd = request.getRequestDispatcher("SignUp.jsp");
                    rsd.forward(request, response);
                }
            }
            if (signUp != null) {
                String loginEmail =  null, name = null, userRoles=null;
                DBCollection collectionS = db.getCollection("userDetails");
                BasicDBObject signUPD = new BasicDBObject();
                BasicDBObject signValidateEmail = new BasicDBObject();
                BasicDBObject signValidateName = new BasicDBObject();
                signValidateEmail.put("loginEmail", request.getParameter("loginEmail"));
                signValidateName.put("password", request.getParameter("password"));
                System.out.println("password"+request.getParameter("password"));
                DBCursor existingEmail = collectionS.find(signValidateEmail);
                
                while (existingEmail.hasNext()) {
                    DBObject objd = existingEmail.next();
                    loginEmail = (String) objd.get("loginEmail");
                }
               

                if (loginEmail == null || name == null) {
                    signUPD.put("userLoginID", generate.generateID("userLogin"));
                    signUPD.put("aid",generate.generateID("aid"));
                    signUPD.put("loginEmail", request.getParameter("loginEmail"));
                    signUPD.put("loginPassword", request.getParameter("password"));
                   
                    signUPD.put("roles","user");
                  
                    collectionS.insert(signUPD);
                    RequestDispatcher rsd = request.getRequestDispatcher("login.jsp");
                    rsd.forward(request, response);
                } else {
                    request.setAttribute("statusfailed", "Email already exists");
                    RequestDispatcher rsd = request.getRequestDispatcher("login.jsp");
                    rsd.forward(request, response);
                }
            }

            if (request.getParameter("logout") != null) {
                String logedInUserName = null;
                Cookie cookie[] = request.getCookies();
                Cookie cookies = null;
                if (cookie != null) {

                    for (int i = 0; i < cookie.length; i++) {
                        cookies = cookie[i];
                        logedInUserName = cookies.getValue();
                    }

                }                                              
                DBCollection usersLogesInID = db.getCollection("loggedInUserDetails");
                BasicDBObject removeUserLogedin = new BasicDBObject();
                removeUserLogedin.put("userName",logedInUserName);
                usersLogesInID.remove(removeUserLogedin);
                RequestDispatcher rsd = request.getRequestDispatcher("login.jsp");
                rsd.forward(request, response);
        }
        }
        finally {
            out.close();
             dbClntConn.close();
        }
    
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
