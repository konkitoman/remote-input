#include <jni.h>
#include <sys/types.h>
#include <thread>
#include <android/log.h>
#include <unistd.h>

struct RemoteInput{
    int handle;
};

extern "C" int RemoteInput_init(struct RemoteInput*, const char* name, const u_int16_t port);
extern "C" void RemoteInput_deinit(struct RemoteInput*);
extern "C" void RemoteInput_press(struct RemoteInput*, const u_int16_t key);
extern "C" void RemoteInput_release(struct RemoteInput*, const u_int16_t key);
extern "C" void RemoteInput_type(struct RemoteInput*, const char* c_text);
extern "C" void RemoteInput_move_x(struct RemoteInput*, int x);
extern "C" void RemoteInput_move_y(struct RemoteInput*, int y);

FILE *stderrFile;

std::thread* m_logThread;

void log_thread(){
    while (true){
        char readBuffer[1024*8];
        fgets(readBuffer, sizeof(readBuffer), stderrFile);
        __android_log_write(ANDROID_LOG_ERROR, "stderr", readBuffer);
    }
}

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved){
    int pipes[2];
    pipe(pipes);
    dup2(pipes[1], STDERR_FILENO);
    stderrFile = fdopen(pipes[0], "r");

    m_logThread = new std::thread(log_thread);
    return JNI_VERSION_1_6;
}

JNIEXPORT void JNI_OnUnload(JavaVM* vm, void* reserved){
    delete m_logThread;
}

extern "C"
JNIEXPORT int JNICALL
Java_com_konkito_remoteinput_RemoteInput_init(JNIEnv *env,
                                                                           jobject thiz,
                                                                           jstring name,
                                                                           jshort port) {
    jclass thiz_class = env->GetObjectClass(thiz);
    jfieldID handle_id = env->GetFieldID(thiz_class, "handle", "I");

    struct RemoteInput remoteInput;
    const char* c_name = env->GetStringUTFChars(name, nullptr);
    __android_log_write(ANDROID_LOG_INFO, "Testd", c_name);
    const int res = RemoteInput_init(&remoteInput, c_name, port);
    env->SetIntField(thiz, handle_id, remoteInput.handle);

    return res;
}

extern "C"
JNIEXPORT void JNICALL
Java_com_konkito_remoteinput_RemoteInput_deinit(JNIEnv *env, jobject thiz) {
    jclass thiz_class = env->GetObjectClass(thiz);
    jfieldID handle_id = env->GetFieldID(thiz_class, "handle", "I");
    struct RemoteInput remoteInput{.handle = env->GetIntField(thiz, handle_id)};
    RemoteInput_deinit(&remoteInput);
}

extern "C"
JNIEXPORT void JNICALL
        Java_com_konkito_remoteinput_RemoteInput_press(JNIEnv *env, jobject thiz, jshort key){
    jclass thiz_class = env->GetObjectClass(thiz);
    jfieldID handle_id = env->GetFieldID(thiz_class, "handle", "I");
    struct RemoteInput remoteInput{.handle = env->GetIntField(thiz, handle_id)};
    RemoteInput_press(&remoteInput, key);
}

extern "C"
JNIEXPORT void JNICALL
Java_com_konkito_remoteinput_RemoteInput_release(JNIEnv *env, jobject thiz, jshort key){
    jclass thiz_class = env->GetObjectClass(thiz);
    jfieldID handle_id = env->GetFieldID(thiz_class, "handle", "I");
    struct RemoteInput remoteInput{.handle = env->GetIntField(thiz, handle_id)};
    RemoteInput_release(&remoteInput, key);
}

extern "C"
JNIEXPORT void JNICALL
Java_com_konkito_remoteinput_RemoteInput_type(JNIEnv *env, jobject thiz, jstring text){
    jclass thiz_class = env->GetObjectClass(thiz);
    jfieldID handle_id = env->GetFieldID(thiz_class, "handle", "I");
    struct RemoteInput remoteInput{.handle = env->GetIntField(thiz, handle_id)};


    const char* c_text = env->GetStringUTFChars(text, nullptr);
    RemoteInput_type(&remoteInput, c_text);
}

extern "C"
JNIEXPORT void JNICALL
Java_com_konkito_remoteinput_RemoteInput_move(JNIEnv *env, jobject thiz, jint x, jint y){
    jclass thiz_class = env->GetObjectClass(thiz);
    jfieldID handle_id = env->GetFieldID(thiz_class, "handle", "I");
    struct RemoteInput remoteInput{.handle = env->GetIntField(thiz, handle_id)};

    RemoteInput_move_x(&remoteInput, x);
    RemoteInput_move_y(&remoteInput, y);
}