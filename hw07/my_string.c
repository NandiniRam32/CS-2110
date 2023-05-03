/**
 * @file my_string.c
 * @author Nandini Ramakrishnan
 * @collaborators NAMES OF PEOPLE THAT YOU COLLABORATED WITH HERE
 * @brief Your implementation of these famous 3 string.h library functions!
 *
 * NOTE: NO ARRAY NOTATION IS ALLOWED IN THIS FILE
 *
 * @date 2023-03-23
 */

#include <stddef.h>
#include "my_string.h"
/**
 * @brief Calculate the length of a string
 *
 * @param s a constant C string
 * @return size_t the number of characters in the passed in string
 */
size_t my_strlen(const char *s)
{
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(s);
    int size_t;
    for (size_t = 0; *s != '\0'; ++size_t) {
        s++;
    }
    return (size_t);
}

/**
 * @brief Compare two strings
 *
 * @param s1 First string to be compared
 * @param s2 Second string to be compared
 * @param n First (at most) n bytes to be compared
 * @return int "less than, equal to, or greater than zero if s1 (or the first n
 * bytes thereof) is found, respectively, to be less than, to match, or be
 * greater than s2"
 */
int my_strncmp(const char *s1, const char *s2, size_t n)
{
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(s1);
    UNUSED_PARAM(s2);
    UNUSED_PARAM(n);
    for (size_t i = 0; i < n; i++) {
        if (*s1 == '\0' || *s2 == '\0') {
            return (*s1 - *s2);
        }
        if (*s1 != *s2) {
            if (*s1 > *s2) {
                return 1;
            } else if (*s1 < *s2) {
                return -1;
            }
        } else {
            s1++;
            s2++;
        }
    }
    return 0;
}

/**
 * @brief Copy a string
 *
 * @param dest The destination buffer
 * @param src The source to copy from
 * @param n maximum number of bytes to copy
 * @return char* a pointer same as dest
 */
char *my_strncpy(char *dest, const char *src, size_t n)
{
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(dest);
    UNUSED_PARAM(src);
    UNUSED_PARAM(n);
    for (size_t i = 0; i < n; src++, i++, dest++) {
        *dest = *src;
    }
    for (size_t i = 0; i < n; dest--, i++);
    return dest;
}

/**
 * @brief Concatenates two strings and stores the result
 * in the destination string
 *
 * @param dest The destination string
 * @param src The source string
 * @param n The maximum number of bytes from src to concatenate
 * @return char* a pointer same as dest
 */
char *my_strncat(char *dest, const char *src, size_t n)
{
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(dest);
    UNUSED_PARAM(src);
    UNUSED_PARAM(n);
    char *pointer = dest;
    while (*pointer != '\0') {
        pointer++;
    }
    size_t i = 0;
    while (i < n && *src != '\0') {
        *pointer = *src;
        i++;
        pointer++;
        src++;
    }
    *pointer = '\0';
    return dest;
}

/**
 * @brief Copies the character c into the first n
 * bytes of memory starting at *str
 *
 * @param str The pointer to the block of memory to fill
 * @param c The character to fill in memory
 * @param n The number of bytes of memory to fill
 * @return char* a pointer same as str
 */
void *my_memset(void *str, int c, size_t n)
{
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(str);
    UNUSED_PARAM(c);
    UNUSED_PARAM(n);
    char *pointer = str;
    for (size_t i = 0; i < n; i++, pointer++) {
        *pointer = c;
    }
    return str;
}

/**
 * @brief Finds the first instance of c in str
 * and removes it from str in place
 *
 * @param str The pointer to the string
 * @param c The character we are looking to delete
 */
void remove_first_instance(char *str, char c){
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(str);
    UNUSED_PARAM(c);
    char *pointer = str;
    while (*str != c) {
        str++;
        pointer++;
        if (*str == '\0') {
            return;
        }
    }
    pointer++;
    while (*pointer != '\0') {
        *str = *pointer;
        str++;
        pointer++;
    }
    *str = '\0';
    return;
}

/**
 * @brief Finds the first instance of c in str
 * and replaces it with the contents of replaceStr
 *
 * @param str The pointer to the string
 * @param c The character we are looking to delete
 * @param replaceStr The pointer to the string we are replacing c with
 */
void replace_character_with_string(char *str, char c, char *replaceStr) {
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    UNUSED_PARAM(str);
    UNUSED_PARAM(c);
    UNUSED_PARAM(replaceStr);
    int length = 0;
    char *lengthPointer = replaceStr;
    while (*lengthPointer != '\0') {
        lengthPointer++;
        length++;
    }
    char *initialPointer = str;
    char *newPointer = str;
    char *extraPointer = str;
    char *lastPointer = str;
    char *replacePointer = replaceStr;
    if (*replacePointer == '\0') {
        char *pointer = str;
        while (*str != c) {
            str++;
            pointer++;
            if (*str == '\0') {
                return;
            }
        }
        pointer++;
        while (*pointer != '\0') {
            *str = *pointer;
            str++;
            pointer++;
        }
        *str = '\0';
        return;
    }
    while (*initialPointer != c) {
        initialPointer++;
        newPointer++;
        extraPointer++;
        lastPointer++;
        if (*initialPointer == '\0') {
            return;
        }
    }
    for (int i = 1; i < length; i++) {
        newPointer++;
    }
    //find length2
    int length2 = 0;
    while (*extraPointer != '\0') {
        length2++;
        extraPointer++;
    }
    for (int i = 0; i < length2; i++) {
        newPointer++;
        initialPointer++;
    }
    for (int i = 0; i < length2; i++) {
        *newPointer = *initialPointer;
        newPointer--;
        initialPointer--;
    }
    for (int i = 0; i < length; i++, lastPointer++, replacePointer++) {
        *lastPointer = *replacePointer;
    }
    /**char *strPointer = str;
    char *replacePointer = replaceStr;
    //strPointer is the pointer to the next place in the string after the deleted character
    int length = 0;
    char *extraPointer = replaceStr;
    //finds th length of replaceStr
    while (*extraPointer != '\0') {
        length++;
        extraPointer++;
    }
    //go to c
    while (*str != c) {
        str++;
        strPointer++;
    }
    strPointer++;
    char *newPointer = strPointer + length;
    while (*strPointer != '\0') {
        *newPointer = *strPointer;
    }
    int i = 0;
    while (i < length) {
        *str = *replacePointer;
    }
    //now, strPointer is at the next character address
    */
    return;
}

/**
 * @brief Remove the first character of str (ie. str[0]) IN ONE LINE OF CODE.
 * No loops allowed. Assume non-empty string
 * @param str A pointer to a pointer of the string
 */
void remove_first_character(char **str) {
    /* Note about UNUSED_PARAM
    *
    * UNUSED_PARAM is used to avoid compiler warnings and errors regarding unused function
    * parameters prior to implementing the function. Once you begin implementing this
    * function, you can delete the UNUSED_PARAM lines.
    */
    *str = (*str + 1);
}