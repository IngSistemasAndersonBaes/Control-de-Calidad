/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
        String url="jdbc:sqlserver://AndersonBaes:50497;databaseName=ControlCalidad;IntegratedSecurity=true;";

    Connection con;
    public Connection getConnection(){
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            //Class.forName("com.mysql.cj.jdbc.Driver");
            con=DriverManager.getConnection(url);
            //con=DriverManager.getConnection(url,"root","root");
        } catch (Exception e) {  
            System.out.println("Error: " + e.getMessage());
        }
        return con;
    }
}
