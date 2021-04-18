using AKS.Project.Sample.Helpers;
using NUnit.Framework;

namespace AKS.Project.Sample.Tests
{
    public class Tests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void PassTest()
        {
            SampleHelper helper = new SampleHelper();
            var sum = helper.Sum(2, 3);
            Assert.AreEqual(5, sum);
        }

        [Test]
        public void PassTest2()
        {
            SampleHelper helper = new SampleHelper();
            var sum = helper.Sum(4, 5);
            Assert.AreEqual(9, sum);
        }
    }
}