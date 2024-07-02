package com.svalero.util;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Utils {


    public static String formatDate (Date date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        return dateFormat.format(date);
    }

    public static Date parseDate (String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return new Date(dateFormat.parse(date).getTime());
    }
}
