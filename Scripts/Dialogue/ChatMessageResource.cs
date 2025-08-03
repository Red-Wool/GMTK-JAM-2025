using Godot;
using System;

[GlobalClass]
public partial class ChatMessageResource : ChatData
{
	[Export] public string name;
	[Export(PropertyHint.MultilineText)] public string message;
	[Export] public float delayStart = 2.5f;
	[Export] public float delayType = 2f;

}
