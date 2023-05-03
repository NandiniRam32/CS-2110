public class Nandini2110HW1Test {
    public static void main(String[] args) {
        testMethod6();
    }
    public static void testMethod(String decimal) {
        int integer = 0;
        for (int i = 0; i < decimal.length(); i++) {
            if (decimal.charAt(i) == '1') {
                integer = integer + 1;
            } else if (decimal.charAt(i) == '2') {
                integer = integer + 2;
            } else if (decimal.charAt(i) == '3') {
                integer = integer + 3;
            } else if (decimal.charAt(i) == '4') {
                integer = integer + 4;
            } else if (decimal.charAt(i) == '5') {
                integer = integer + 5;
            } else if (decimal.charAt(i) == '6') {
                integer = integer + 6;
            } else if (decimal.charAt(i) == '7') {
                integer = integer + 7;
            } else if (decimal.charAt(i) == '8') {
                integer = integer + 8;
            } else if (decimal.charAt(i) == '9') {
                integer = integer + 9;
            }
            System.out.println("1: " + integer);
            integer = integer*10;
            System.out.println("2: " + integer);
        }
        integer = integer/10;
        System.out.println(integer);
    }
    public static void testMethod2(String decimal) {
        int integer = 0;
        for (int i = 0; i < decimal.length(); i++) {
            System.out.println((int) decimal.charAt(i));
            integer = integer + ((int)decimal.charAt(i) - 48);
            System.out.println("1: " + integer);
            integer = integer*10;
            System.out.println("2: " + integer);
        }
        integer = integer/10;
        System.out.println(integer);
    }
    public static void testMethod3(String binary) {
        int integer = 0;
        for (int i = 0; i < binary.length() - 1; i++) {
            if (binary.charAt(i) == '1') {
                integer = integer + (2 << (binary.length() - 2 - i));
            }
        }
        if (binary.charAt(binary.length() - 1) == '1') {
            integer++;
        }
        System.out.println(integer);
    }
    public static void testMethod4(String binary) {
        int integer = 0;
        for (int i = 0; i < binary.length() - 1; i++) {
            if (binary.charAt(i) == '1') {
                integer = integer + (2 << (binary.length() - 2 - i));
            }
        }
        if (binary.charAt(binary.length() - 1) == '1') {
            integer++;
        }
        String binaryString = "0123456789ABCDEF";
        String returnString = "";
        int quotient = integer;
        char temp = '\0';
        while (quotient > 0) {
            quotient = quotient >> 4;
            if ((integer & 15) >= 10) {
                temp = (char) ((integer & 15) - 10 + 'A');
                returnString = temp + returnString;
                integer = quotient;
            } else {
                returnString = (integer & 15) + returnString;
                integer = quotient;
            }
            temp = 0;
        }
        for (int i = returnString.length(); i < 8; i++) {
            returnString = "0" + returnString;
        }
        System.out.println(returnString);
    }
    public static void testMethod5(String binary) {
        int integer = 0;
        for (int i = 0; i < binary.length() - 1; i++) {
            if (binary.charAt(i) == '1') {
                integer = integer + (2 << (binary.length() - 2 - i));
            }
        }
        if (binary.charAt(binary.length() - 1) == '1') {
            integer++;
        }
        String binaryString = "0123456789ABCDEF";
        String returnString = "";
        int quotient = integer;
        while ((integer > 0) && returnString.length() < 8) {
            quotient = quotient >> 4;
            returnString = binaryString.charAt(integer & 0xF) + returnString;
            integer <<= 4;
        }
        System.out.println(returnString);
    }
    public static void testMethod6() {
        String binary = ((0b1111 << ((0 ^ (0x1)) << 2))) + "";
        int b = ((0b1111111100 >> ((0 ^ (0x1)) << 4)));
        int c;
        int d;
        b = ((65282 & (255 << (1 ^ 0x1) << 7)) >> 7);
     //   b = ((num & ((255 << ((which ^ (0x1)) << 7)))) >> (((which ^ (0x1)) << 7)));
        b = 23345767 & (0xFFFF << (4 & (0)));
        c = 0xF << 3;
        d = 1111111123 & (0xFF00);
        System.out.println(b + " " + c);
        System.out.println((0xFFFFFFFF & (01 << 4)) & (01 << 2));
        System.out.println((-4 & 0b10000000000000000000000000000000) >> 31);
      //  System.out.println((8 & (1 << (A digit from 1 - 31))) == 8);
    }
}