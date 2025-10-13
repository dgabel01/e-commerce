import medusa from "@/lib/medusa"

export default async function ProductsPage() {
  let products = []

  try {
    const res = await medusa.products.list({ limit: 5 }) 
    products = res.products
  } catch (error) {
    console.error("Error fetching products:", error)
  }

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">Products Test</h1>
      {products.length === 0 ? (
        <p>No products found</p>
      ) : (
        <ul className="space-y-2">
          {products.map((p) => (
            <li key={p.id} className="border p-2 rounded">
              <h2 className="font-semibold">{p.title}</h2>
              <p>{p.description}</p>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
