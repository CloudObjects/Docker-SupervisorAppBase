php /tmp/lighttpd.conf.php $PHP_PROCESS_COUNT > /etc/lighttpd/lighttpd.conf

if [ -d "/var/www/app" ]; then
	echo "Application directory mounted."
	echo "Starting supervisor ..."
	supervisord -n -c /var/www/app/supervisord.conf
else
if [ -z "$PACKAGE_ZIP_URL" ]
then
	echo "No application package defined to install."
else
	mkdir /var/www/app/
	echo "Installing application package ..."
  	# Download package from URL
	/usr/bin/curl $PACKAGE_ZIP_URL > /tmp/pkg.zip
	if [ "$?" = "0" ]
	then
		# Unzip package into app directory
		/usr/bin/unzip /tmp/pkg.zip -d /var/www/app/
		if [ "$?" = "0" ]
		then
			# Run init script if it exists
			if [ -f /var/www/app/init.sh ]
			then
				echo "Running init script ..."
				cd /var/www/app/
				/bin/sh init.sh
			fi
			echo "Starting supervisor ..."
			supervisord -n -c /var/www/app/supervisord.conf
		fi
	else
		echo "The application package could not be installed."
	fi
fi
fi
