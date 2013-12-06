NAME=plymouth-theme-doge
VERSION=$(shell rpm --eval "`cat $(NAME).spec`" | sed -n 's/ *Version: *//p')
RELEASE=$(shell rpm --eval "`cat $(NAME).spec`" | sed -n 's/ *Release: *//p')

.PHONY: all srpm rpm nvr clean
all: srpm rpm
srpm: $(NAME)-$(VERSION)-$(RELEASE).src.rpm
rpm: $(NAME)-$(VERSION)-$(RELEASE).noarch.rpm

$(NAME)-$(VERSION).tar.bz2:
	git archive --format=tar --prefix=$(NAME)-$(VERSION)/ HEAD | bzip2 -9 > $@
$(NAME)-$(VERSION)-$(RELEASE).src.rpm: $(NAME).spec $(NAME)-$(VERSION).tar.bz2
	rpmbuild --define '_sourcedir .' --define '_srcrpmdir .' -bs $(NAME).spec
$(NAME)-$(VERSION)-$(RELEASE).noarch.rpm: $(NAME).spec $(NAME)-$(VERSION).tar.bz2
	mkdir -p BUILD
	rpmbuild --define "_rpmdir $(PWD)" --define '_builddir %_rpmdir/BUILD' --define '_sourcedir %_rpmdir' -bb $(NAME).spec
	mv noarch/$@ .
	rmdir noarch

nvr:
	@echo $(NAME)-$(VERSION)-$(RELEASE)
clean:
	rm -f $(NAME)-$(VERSION).tar.bz2 $(NAME)-$(VERSION)-$(RELEASE).{src,noarch}.rpm
	rm -rf BUILD
