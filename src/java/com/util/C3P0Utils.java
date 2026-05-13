package com.util;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class C3P0Utils {  
    private static final ComboPooledDataSource dataSource = new ComboPooledDataSource();
    
    static {
        try {
            
            dataSource.setDriverClass("com.mysql.cj.jdbc.Driver");
            dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/registeruser?useSSL=false&serverTimezone=UTC");
            dataSource.setUser("root");
            dataSource.setPassword("root");
            
            
            dataSource.setInitialPoolSize(5);
            dataSource.setMinPoolSize(5);
            dataSource.setMaxPoolSize(20);
            dataSource.setAcquireIncrement(2);
            dataSource.setMaxIdleTime(300);
            dataSource.setTestConnectionOnCheckout(true);
            dataSource.setIdleConnectionTestPeriod(1800);
        } catch (Exception e) {
            throw new RuntimeException("C3P0连接池初始化失败", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    public static void closeDataSource() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}