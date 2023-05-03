// DO NOT MODIFY THE INCLUDE(S) LIST
#include <stdio.h>
#include "oh_queue.h"

struct Queue oh_queue;

/** push
 * @brief Create a new student and push him
 * onto the OH queue
 * @param studentName pointer to the student's name
 * @param topicName topic the student has a question on
 * @param questionNumber hw question number student has a question on
 * @param pub_key public key used for calculating the hash for customID
 * @return FAILURE if the queue is already at max length, SUCCESS otherwise
 */
int push(const char *studentName, const enum subject topicName, const float questionNumber, struct public_key pub_key){
    UNUSED_PARAM(studentName);
    UNUSED_PARAM(topicName);
    UNUSED_PARAM(questionNumber);
    UNUSED_PARAM(pub_key);
    if (oh_queue.stats.no_of_people_in_queue == MAX_QUEUE_LENGTH) {
        return (FAILURE);
    } else if (studentName == NULL) {
        return (FAILURE);
    }
    struct Student newStudent;
    struct StudentData newStudentData;
    struct Topic topic;
    topic.topicName = topicName;
    topic.questionNumber = questionNumber;
    newStudentData.topic = topic;
    size_t length = my_strlen(studentName);
    size_t i = 0;
    if (length >= MAX_NAME_LENGTH) {
        newStudentData.name[MAX_NAME_LENGTH - 1] = '\0';
        while (i < MAX_NAME_LENGTH - 1) {
            newStudentData.name[i] = *studentName;
            studentName++;
            i++;
        }
    } else {
        while (i <= length) {
            newStudentData.name[i] = *studentName;
            studentName++;
            i++;
        }
    }
    newStudent.studentData = newStudentData;
    hash(newStudent.customID, newStudentData.name, pub_key);
    newStudent.queue_number = oh_queue.stats.no_of_people_visited + oh_queue.stats.no_of_people_in_queue;
    oh_queue.students[oh_queue.stats.no_of_people_in_queue++] = newStudent;
    OfficeHoursStatus(&oh_queue.stats);
    return (SUCCESS);
}

/** pop
 * @brief Pop a student out the OH queue
 * @return FAILURE if the queue is already at empty, SUCCESS otherwise
 */
int pop(void) {
    if (oh_queue.stats.no_of_people_in_queue == 0) {
        return FAILURE;
    }
    for (int i = 1; i < oh_queue.stats.no_of_people_in_queue; i++) {
        oh_queue.students[i - 1] = oh_queue.students[i];
    }
    oh_queue.stats.no_of_people_in_queue--;
    oh_queue.stats.no_of_people_visited++;
    OfficeHoursStatus(&oh_queue.stats);
    return SUCCESS;
}

/** group_by_topic
 * @brief Push pointers to students, who match the given topic, to
 * the given array "grouped"
 * @param topic the topic the students need to match
 * @param grouped an array of pointers to students
 * @return the number of students matched
 */
int group_by_topic(struct Topic topic, struct Student *grouped[]) { 
    UNUSED_PARAM(topic);
    UNUSED_PARAM(grouped);
    int numberMatched = 0;
    int size = oh_queue.stats.no_of_people_in_queue;
    for (int i = 0; i < size; i++) {
        if (topic.topicName == oh_queue.students[i].studentData.topic.topicName) {
            if (topic.questionNumber == oh_queue.students[i].studentData.topic.questionNumber) {
                grouped[numberMatched] = &oh_queue.students[i];
                numberMatched++;
            }
        }
    }
    return (numberMatched);
}

/** hash
 * @brief Creates a hash based on pub_key provided
 * @param ciphertext the pointer where you will store the hashed text
 * @param plaintext the originak text you need to hash
 * @param pub_key public key used for calculating the hash
 */
void hash(int *ciphertext, char *plaintext, struct public_key pub_key) {
    UNUSED_PARAM(ciphertext);
    UNUSED_PARAM(plaintext);
    UNUSED_PARAM(pub_key);
    char *plaintextPointer = plaintext;
    int *ciphertextPointer = ciphertext;
    while (*plaintextPointer != '\0') {
        *ciphertextPointer = power_and_mod((int) *plaintextPointer, pub_key.e, pub_key.n);
        ciphertextPointer++;
        plaintextPointer++;
    }
    *ciphertextPointer = '\0';
    return;
}

/** update_student
 * @brief Find the student with the given ID and update his topic
 * @param customID a pointer to the id of the student you are trying to find
 * @param newTopic the new topic that should be assigned to him
 * @return FAILURE if no student is matched, SUCCESS otherwise
 */
int update_student(struct Topic newTopic, int *customID) {
    UNUSED_PARAM(newTopic);
    UNUSED_PARAM(customID);
    for (int i = 0; i < oh_queue.stats.no_of_people_in_queue; i++) {
        if (*oh_queue.students[i].customID == *customID) {
            oh_queue.students[i].studentData.topic.topicName = newTopic.topicName;
            oh_queue.students[i].studentData.topic.questionNumber = newTopic.questionNumber;
            return (SUCCESS);
        }
    }
    return (FAILURE);
}

/** remove_student_by_name
 * @brief Removes first instance of a student with the given name
 * @param name the name you are searching for
 * @return FAILURE if no student is matched, SUCCESS otherwise
 */
int remove_student_by_name(char *name) {
    UNUSED_PARAM(name);
    int size = oh_queue.stats.no_of_people_in_queue;
    //int returnValue = 0;
    for (int i = 0; i < size; i++) {
        if (my_strncmp(name, oh_queue.students[i].studentData.name, MAX_NAME_LENGTH) == 0) {
            for (int j = i; j < size - 1; j++) {
                oh_queue.students[j] = oh_queue.students[j + 1];
            }
            oh_queue.stats.no_of_people_in_queue--;
            oh_queue.stats.no_of_people_visited++;
            OfficeHoursStatus(&oh_queue.stats);
            //returnValue = 1;
            return (SUCCESS);
        }
    }
    //return (returnValue == 1 ? SUCCESS : FAILURE);
    return (FAILURE);
}

/** remove_student_by_topic
 * @brief Remove all instances of students with the given topic
 * @param topic the topic you are trying to remove from the queue
 * @return FAILURE if no student is matched, SUCCESS otherwise
 */
int remove_student_by_topic(struct Topic topic) {
    UNUSED_PARAM(topic);
    int size = oh_queue.stats.no_of_people_in_queue;
    int returnValue = 0;
    for (int i = 0; i < size; i++) {
        if (topic.topicName == oh_queue.students[i].studentData.topic.topicName) {
            if (topic.questionNumber == oh_queue.students[i].studentData.topic.questionNumber) {
                for (int j = i; j < size - 1; j++) {
                    oh_queue.students[j] = oh_queue.students[j + 1];
                }
                i--;
                oh_queue.stats.no_of_people_in_queue--;
                oh_queue.stats.no_of_people_visited++;
                returnValue = 1;
                size = oh_queue.stats.no_of_people_in_queue;
                OfficeHoursStatus(&oh_queue.stats);
            }
        }
    }
    return (returnValue == 1 ? SUCCESS : FAILURE);
}

/** OfficeHoursStatus
 * @brief Updates the "currentStatus" field based on
 * whether or not all students in the queue have been helped
 * @param resultStats A pointer the OfficeHoursStats variable
 * you are to update
 */
void OfficeHoursStatus(struct OfficeHoursStats* resultStats){
    UNUSED_PARAM(resultStats);
    if (oh_queue.stats.no_of_people_in_queue == 0) {
        resultStats->currentStatus = "Completed";
    } else {
        resultStats->currentStatus = "InProgress";
    }
    return;
}

/*
 * Calculates (b^e)%n without overflow
 */
int power_and_mod(int b, int e, int n) {
    long int currNum = 1;
    for (int i = 0; i < e; i++) {
        currNum *= b;
        if (currNum >= n) {
            currNum %= n;
        }
    }
    return (int) (currNum % n);
}