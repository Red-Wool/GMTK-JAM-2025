using Godot;
using System;
[GlobalClass]
public partial class ChatEventAnimation : ChatEvent
{
	[Export] NodePath AnimationPlayerPath;
	[Export] StringName animationName;
	public override void Trigger(Chatbox chatbox)
	{
		base.Trigger(chatbox);
		chatbox.GetNode<AnimationPlayer>(AnimationPlayerPath).Play(animationName);
	} 
}
