using Godot;
using System;

public partial class Chatbox : Panel
{
	[Export] public Godot.Collections.Array<ChatData> chatMessages;
	[Export] public string textBoxResource = "uid://cv6gbu6jorb6k";
	[Signal]
	public delegate void FinishedDialogueEventHandler();
	VBoxContainer chatContainer;
	Label nameTyping;
	[Export] public Color FORColor;
	[Export] public Color WHILEColor;
	SceneTreeTimer timer;
	bool doSkip = false;

	public override void _Ready()
	{
		chatContainer = GetNode<VBoxContainer>("ScrollContainer/VBoxContainer");
		nameTyping = GetNode<Label>("Label");
		ProcessDialogue(0);
	}

	public override void _Process(double delta)
	{
		if (Input.IsActionJustPressed("ui_accept"))
		{
			timer.SetTimeLeft(0.01f);
			doSkip = true;
		}
	}

	public async void ProcessDialogue(int index)
	{
		int currentIndex = index;

		while (index < chatMessages.Count)
		{
			if (chatMessages[index] is ChatMessageResource chat)
			{
				timer = GetTree().CreateTimer(chat.delayStart);
				await ToSignal(timer, "timeout");

				nameTyping.Visible = true;
				nameTyping.Text = chat.name + " is typing...";

				if (!doSkip)
				{
					timer = GetTree().CreateTimer(chat.delayType);
					await ToSignal(timer, "timeout");
				}

				nameTyping.Visible = false;

				if (chat.message != "")
				{
					var scene = GD.Load<PackedScene>(textBoxResource);
					var inst = scene.Instantiate();
					chatContainer.AddChild(inst);

					RichTextLabel message = (RichTextLabel)inst;
					message.Text = chat.message;

					if (chat.name == "FOR")
					{
						message.Modulate = FORColor;
					}
					if (chat.name == "WHILE")
					{
						message.Modulate = WHILEColor;
					}

					if (chatContainer.GetChildCount() > 5)
					{
						chatContainer.GetChild(0).QueueFree();
					}
				}
				GetNode<ScrollContainer>("ScrollContainer").ScrollVertical = 1000;
				index++;

				doSkip = false;
				
			}
			else if (chatMessages[index] is ChatEvent chatEvent)
			{
				chatEvent.Trigger(this);
				index++;
			}
		}

		EmitSignal(SignalName.FinishedDialogue);
	}
}
