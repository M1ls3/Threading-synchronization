using System.Threading.Tasks;

namespace TreadMinCS
{
    public class Program
    {
        private static readonly int dim = 10000000;
        private const int threadsCount = 4;
        private Thread[] threads = new Thread[threadsCount];
        private readonly int[] arr = new int[dim];
        private int minIndex;
        private int minValue = int.MaxValue;

        static void Main(string[] args) => Handler();

        static void Handler()
        {
            Program program = new Program();
            program.InitArr();
            program.RunParallelThreads();

            Console.WriteLine($"Min value: [{program.minIndex}] = {program.minValue}");
            Console.ReadKey();
        }

        private void InitArr()
        {
            Random rnd = new Random();
            for (int i = 0; i < dim; i++)
            {
                arr[i] = rnd.Next(10000000); // Fill up array
            }
            arr[rnd.Next(dim)] = rnd.Next(-10000000,-1);
        }

        private void RunParallelThreads()
        {
            int partSize = dim / threadsCount;
            for (int i = 0; i < threadsCount; i++)
            {
                int start = i * partSize;
                int end = (i == threadsCount - 1) ? dim : (i + 1) * partSize;
                threads[i] = new Thread(() => FindMin(start, end)); // anonymous function 
                threads[i].Start();
            }

            foreach (Thread t in threads)
            {
                t.Join(); // Wait for thread will complate work
            }
        }

        private void FindMin(int start, int end)
        {
            int min = int.MaxValue;
            int index = -1;
            for (int i = start; i < end; i++)
            {
                if (arr[i] < min)
                {
                    min = arr[i];
                    index = i;
                }
            }

            lock (this) // Block access for threads
            {
                if (min < minValue)
                {
                    minValue = min;
                    minIndex = index;
                }
            }
        }
    }
}