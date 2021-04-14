
typedef Object EventHandler(Object o);

class EventBroadcast 
{
	//delegate object EventHandler(object o); 
	static Map<String, EventHandler> eventList = new Map<String, EventHandler>();

	static void addEvent(String s, EventHandler e)
	{
		if (eventList.containsKey(s))
		{
			print("Failed to add event " + s);
			return;
		}
		eventList[s] = e;
	}

	static Object triggerEvent(String key, Object param)
	{
		if (!eventList.containsKey(key))
		{
			return null;
		}

		return eventList[key].call(param);
	}
}
