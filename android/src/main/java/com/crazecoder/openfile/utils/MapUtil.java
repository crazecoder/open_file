package com.crazecoder.openfile.utils;

import java.util.HashMap;
import java.util.Map;

public class MapUtil {
    public static Map<String, Object> createMap(int type, String message) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("type", type);
        map.put("message", message);
        return map;
    }
}
