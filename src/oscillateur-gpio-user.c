//http://www.blaess.fr/christophe/2012/05/09/gpio-pandaboard-temps-reel-1/

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static volatile int exit_loop = 0;

void handler_signal(int unused)
{
	exit_loop = 1;
}

int main(int argc, char * argv[])
{
	int value = 1;
	char path[256];
	int gpio = 138;
	FILE * fp;
	
	// En argument on peut preciser un GPIO different de 138
	if ((argc > 2) || ((argc == 2) && (sscanf(argv[1], "%d", & gpio) != 1))) {
		fprintf(stderr, "usage: %s [gpio]\n", argv[0]);
		exit(EXIT_FAILURE);
	}
	
	// Exporter le GPIO dans le systeme de fichiers
	snprintf(path, 256, "/sys/class/gpio/export");
	if ((fp = fopen(path, "w")) == NULL) {
		perror(path);
		exit(EXIT_FAILURE);
	}
	fprintf(fp, "%d\n", gpio);
	fclose(fp);
	
	// Intercepter Controle-C pour finir proprement
	signal(SIGINT, handler_signal);
	
	// Basculer le GPIO en sortie
	snprintf(path, 256, "/sys/class/gpio/gpio%d/direction", gpio);
	if ((fp = fopen(path, "w")) == NULL) {
		perror(path);
		exit(EXIT_FAILURE);
	}
	fprintf(fp, "out\n");
	fclose(fp);
	
	// Ecrire alternativement la valeur du GPIO
	snprintf(path, 256, "/sys/class/gpio/gpio%d/value", gpio);
	if ((fp = fopen(path, "w")) == NULL) {
		perror(path);
		exit(EXIT_FAILURE);
	}
	while (! exit_loop) {
		fprintf(fp, "%d\n", value);
		fflush(fp);
		value = 1 - value;
		usleep(1000);
	}
	
	// De-exporter le GPIO du systeme de fichiers
	if ((fp = fopen("/sys/class/gpio/unexport", "w")) == NULL) {
		perror("/sys/class/gpio/unexport");
		exit(EXIT_FAILURE);
	}
	fprintf(fp, "%d\n", gpio);
	fclose(fp);
	return EXIT_SUCCESS;
}
