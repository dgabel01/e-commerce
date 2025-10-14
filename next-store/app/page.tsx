import Link from "next/link";

export default function Home() {
  return (
    <div>
      <p>Homepage</p>
      <Link href="/products" className="p-4 text-blue-500 underline">
        <p>Products page</p>
      </Link>
    </div>
  );
}
