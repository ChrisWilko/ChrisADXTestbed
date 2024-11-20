namespace ChrisADXTestbed.Web.Models;

public class Counter
{
    public int CurrentCount { get; private set; } = 0;

    public void IncrementCount()
    {
        CurrentCount++;
    }
}