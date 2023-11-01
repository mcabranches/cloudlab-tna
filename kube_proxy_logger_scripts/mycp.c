#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>

int cp(const char *to, const char *from)
{
    int fd_to, fd_from;
    char buf[4096];
    ssize_t nread;
    int saved_errno;

    printf("Copying %s to %s\n", from, to);

    fd_from = open(from, O_RDONLY);
    if (fd_from < 0)
        return -1;
    printf("Opened original file %s\n", from);

    fd_to = open(to, O_WRONLY | O_CREAT | O_EXCL, 0777);
    if (fd_to < 0) {
    	if (remove(to) != 0) {
	    goto out_error;
	}
    	fd_to = open(to, O_WRONLY | O_CREAT | O_EXCL, 0777);
    	if (fd_to < 0) {
            goto out_error;
    	}
    }
    printf("Opened new file %s\n", to);

    while (nread = read(fd_from, buf, sizeof buf), nread > 0)
    {
	printf("Read %ld bytes\n", nread);
        char *out_ptr = buf;
        ssize_t nwritten;

        do {
            nwritten = write(fd_to, out_ptr, nread);

            if (nwritten >= 0)
            {
                nread -= nwritten;
                out_ptr += nwritten;
            }
            else if (errno != EINTR)
            {
                goto out_error;
            }
        } while (nread > 0);
    }

    if (nread == 0)
    {
        if (close(fd_to) < 0)
        {
            fd_to = -1;
            goto out_error;
        }
        close(fd_from);

	printf("Success!\n");
        /* Success! */
        return 0;
    }

  out_error:
    saved_errno = errno;

    close(fd_from);
    if (fd_to >= 0)
        close(fd_to);

    errno = saved_errno;
    return -1;
}

int main(int argc, char* argv[]) {
    cp(argv[2], argv[1]);
}


