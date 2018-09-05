public class CircularJava {
    public final CircularScala other;

    public CircularJava() {
        other = new CircularScala(this);
    }
}
