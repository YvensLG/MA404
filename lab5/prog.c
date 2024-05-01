#define STDIN_FD  0
#define STDOUT_FD 1

int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

int dectoint(char str[], int ini){
    int s = (str[ini+1]- '0') * 1000 + (str[ini+2]- '0') * 100 + (str[ini+3]- '0') * 10 + (str[ini+4]- '0') * 1;

    if(str[ini] == '-') s = -s;

	return s;
}

int pot(int p){
    int a = 1;
    for(int i = 0; i < p; i ++){
        a *= 2;
    }
    return a;
}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

int main(){
    char s[50];
	int sz = read(STDIN_FD, s, 50);
    
    int a1 = dectoint(s, 0);
    int a2 = dectoint(s, 6);
    int a3 = dectoint(s, 12);
    int a4 = dectoint(s, 18);
    int a5 = dectoint(s, 24);

    a1 = a1 & (pot(5) - 1);
    a2 = a2 & (pot(7) - 1);
    a3 = a3 & (pot(9) - 1);
    a4 = a4 & (pot(4) - 1);
    a5 = a5 & (pot(7) - 1);

    int res = a1 + a2 * pot(5) + a3 * pot(12) + a4 * pot(21) + a5 * pot(25);

    hex_code(res);
}