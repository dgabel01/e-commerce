import Medusa from "@medusajs/medusa-js"

const medusa = new Medusa({
  baseUrl: process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "",
  maxRetries: 3,
  publishableApiKey: process.env.NEXT_PUBLIC_MEDUSA_API_KEY || "",
})

export default medusa
