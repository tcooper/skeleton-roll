PKGROOT            = /opt/skeleton
NAME               = skeleton
VERSION            = 1.0
RELEASE            = 1
TARBALL_POSTFIX    = tgz

SRC_SUBDIR         = skeleton

SOURCE_NAME        = $(NAME)
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)
