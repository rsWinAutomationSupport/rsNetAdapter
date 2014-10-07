rsNetAdapter
============

Collection of resources used for configuration of NIC properties not exposed natively.

rsNetAdapter - Rename and enforce NIC naming

rsNetAdapterBindings - Toggle NIC protocol bindings (ipv6, client for ms networks, etc)


Usage examples:

rsNetAdapter
<pre>
	rsNetAdapter SetDefaultNic0
	{
		InterfaceDescription = "Citrix PV Network Adapter #0"
		Name = "Public"
	}
	
	rsNetAdapter SetDefaultNic1
	{
		InterfaceDescription = "Citrix PV Network Adapter #1"
		Name = "Private"
	}	
</pre>

rsNetAdapterBindings
<pre>
	rsNetAdapterBindings msclient_priv
	{
		Name = "Client for MS Networks - Priv NIC"
		Adapter = "Private"
		ComponentID = "ms_msclient"
		Ensure = "Present"
	}
</pre>