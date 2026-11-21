using Godot;
using System;

public partial class ShipMovement : Node2D
{
    Vector2 movementDirection = Vector2.Up;

    

    [Export] float verticalInputAccel = 0.2f;
    [Export] float horizontalInputAccel = 0.1f;

	[Export] float speed = 10;
	[Export] float acceleration = 1f;

	[Export] float turningSpeed = 1;

    // inputs gain strength over time while held.
    // gradually reset

	Vector2 input;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
        input = Vector2.Zero;

        if (Input.IsActionPressed("Up"))
        {
            input.X += 1;
        }
        else if (Input.IsActionPressed("Down"))
        {
            input.X -= 1;
        }
        else
        {   // decay

        }

        if (Input.IsActionPressed("Right"))
        {
            input.Y += 1;
        }
        else if (Input.IsActionPressed("Left"))
        {
            input.Y -= 1;
        }
        else
        {   // decay

        }

        // normalize input
        input = input.Normalized();

        // calc angle to input from current
        float vecDotProduct = input.X * movementDirection.X + input.Y * movementDirection.Y;
        float angle = Mathf.Acos(vecDotProduct / (input.Length() * movementDirection.Length()));
        GD.Print(angle);
    }

    public void UpdateMovementDirection()
    {

    }
}
