package com.util;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.concurrent.TimeUnit;
import java.sql.Timestamp; 

public class TokenUtil {
    private static final SecureRandom secureRandom = new SecureRandom();
    private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder();
    private static final int TOKEN_VALID_DAYS = 7;

    public static String generateToken() {
        byte[] randomBytes = new byte[24];
        secureRandom.nextBytes(randomBytes);
        return base64Encoder.encodeToString(randomBytes);
    }

    public static Timestamp calculateExpiryDate() {  
        return new Timestamp(System.currentTimeMillis() + TimeUnit.DAYS.toMillis(TOKEN_VALID_DAYS));}
}