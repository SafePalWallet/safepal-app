package io.safepal.example;

import java.util.Arrays;

public class ClearUtil {

    public static void clearBytes(byte[] data) {
        if (data == null) {
            return;
        }
        Arrays.fill(data, 0, data.length, (byte)0);
    }

}
