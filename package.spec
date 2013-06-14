# %global __os_install_post %{nil} would stop compression
 
Name: Name
Summary: Summary
Version: Version
Release: 1
Group: Development/Libraries
License: Commercial
 
%description
 
%prep
 
%build
 
%files
%defattr(755,%{group},%{user})
/opt/%{name}/%{version}
 
%pre
echo pre-install
 
%install
env
echo install
 
%post
echo post-install
chown -R %{group}:%{user} /opt/%{name}/%{version}
chmod +x /opt/%{name}/%{version}/bin/*
 
%preun
echo pre-uninstall
 
%uninstall
echo uninstall
 
%postun
echo post-uninstall