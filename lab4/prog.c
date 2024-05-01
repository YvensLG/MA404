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

#define STDIN_FD  0
#define STDOUT_FD 1

int dectoint(char str[], int sz){
	sz--;
	int res = 0;
	int pot = 1;
	for(int i = 1 + (str[0] == '-'); i < sz; i++){
		pot*=10;
	}
	
	for(int i = 0 + (str[0] == '-'); pot != 0; pot /= 10, i++){
		res += pot * (str[i] - '0');
	}

	if(str[0] == '-') res = -res;

	return res;
}

int hextoint(char str[], int sz){
	sz--;
	int res = 0;
	int pot = 1;
	for(int i = 3; i < sz; i++){
		pot*=16;
	}
	
	for(int i = 2; pot != 0; pot /= 16, i++){
		if(str[i] <= '9'){
			res += pot * (str[i] - '0');
		}
		else{
			res += pot * (str[i] - 'a' + 10);
		}	
	}

	return res;
}

void inttobin(int a, char str[]){
	int aux = a;
	if(a < 0){
		aux = ~(a);
	}
	int pos = 31;
	for(int i = pos; i >= 0; i--){
		if(a >= 0){
			str[i] = '0' + aux % 2;
		}
		else{
			str[i] = '1' - aux % 2;
		}
		aux/=2;
	}
	str[32] = '\n';
}

void inttodec(int a, char str[]){
	if(a == 0){
        for(int i = 0; i <= 2; i++){      //caso separado pro 0 aparecer quando for imprimir
			str[i] = "0\n"[i];
		}
		return;
    }
	if(a == -2147483648){                 //caso separado pois -a não cabe em int
		for(int i = 0; i <= 11; i++){
			str[i] = "-2147483648\n"[i];
		}
		return;
	}

	int cont = 0;
	for(int i = a; i != 0; i/=10) cont++;
	int b = a;

	if(a < 0){
		b = -a;
		cont+=1;
	}

	for(int i = cont; i != 0; i--, b/=10){
		str[i-1] = '0' + b % 10;
	}

	if(a < 0){
		str[0] = '-';
	}

	str[cont] = '\n';
	return;
}

void inttohex(int a, char str[]){
	char s[50];
	inttobin(a, s);

	for(int i = 0; i < 8; i++){
		int aux = 0;
		aux += (s[4*i+0] - '0') * 8;
		aux += (s[4*i+1] - '0') * 4;
		aux += (s[4*i+2] - '0') * 2;
		aux += (s[4*i+3] - '0') * 1;
		if(aux >= 10) str[i] = 'a' + aux - 10;
		else str[i] = '0' + aux;
	}
	str[8] = '\n';	
}

void inttooct(int a, char str[]){
	char s[50];
	inttobin(a, s);

	str[0] = (s[0] - '0') * 2 + (s[1] - '0') * 1 + '0';

	for(int i = 1; i < 11; i++){
		int aux = 0;
		aux += (s[3*i-1] - '0') * 4;
		aux += (s[3*i+0] - '0') * 2;
		aux += (s[3*i+1] - '0') * 1;
		str[i] = '0' + aux;
	}
	str[11] = '\n';	
}

void swap(char* a, char* b){
	char x;
	x = *a;
	*a = *b;
	*b = x;
}

void endianhex(char str[]){
	swap(&str[0], &str[6]);
	swap(&str[1], &str[7]);
	swap(&str[2], &str[4]);
	swap(&str[3], &str[5]);
}

void unsginttodec(unsigned int a, char str[]){
	if(a == 0){
        for(int i = 0; i <= 2; i++){      //caso separado pro 0 aparecer quando for imprimir
			str[i] = "0\n"[i];
		}
		return;
    }

	int cont = 0;
	for(unsigned int i = a; i != 0; i/=10) cont++;
	unsigned int b = a;

	if(a < 0){
		b = -a;
		cont+=1;
	}

	for(int i = cont; i != 0; i--, b/=10){
		str[i-1] = '0' + b % 10;
	}

	str[cont] = '\n';
	return;
}

void prepara(char str[], int x){
	int sz;
	if(x == 1) sz = 32;
	if(x == 3) sz = 11;
	if(x == 4) sz = 8;

	for(int i = sz; i >= 0; i--){
		str[i+2] = str[i];
	}

	str[0] = '0';
	if(x == 1) str[1] = 'b';
	if(x == 3) str[1] = 'o';
	if(x == 4) str[1] = 'x';

	int zeros = 0;

	for(int i = 2; i < sz + 1; i++){
		if(str[i] == '0') zeros++;
		else break;
	}
	
	for(int i = 2; i <= sz + 2 - zeros; i++){
		str[i] = str[i+zeros];
	}
}

int strsize(char str[]){
	int cont;
	for(cont = 0; str[cont] != '\n'; cont++);
	return cont + 1;
}

int main()
{
	char buffer[50];
	int sz = read(STDIN_FD, buffer, 50);

	int n;
	if(buffer[1] == 'x') n = hextoint(buffer, sz);
	else n = dectoint(buffer, sz);

	char strbin[50];
	inttobin(n, strbin);
	prepara(strbin, 1);
	write(STDOUT_FD, strbin, strsize(strbin));

	char strdec[50];
	inttodec(n, strdec);
	write(STDOUT_FD, strdec, strsize(strdec));
	
	char strend[50];
	inttohex(n, strend);
	endianhex(strend);
	prepara(strend, 4);
	unsginttodec(hextoint(strend, strsize(strend)), strend);
	write(STDOUT_FD, strend, strsize(strend));	

	char strhex[50];
	inttohex(n, strhex);
	prepara(strhex, 4);
	write(STDOUT_FD, strhex, strsize(strhex));	

	char stroct[50];	
	inttooct(n, stroct);
	prepara(stroct, 3);
	write(STDOUT_FD, stroct, strsize(stroct));	

	return 0;
}