defmodule WsprHub.Guardian do
  use Guardian, otp_app: :wspr_hub

  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _), do: {:error, :not_found}

  def resource_from_claims(%{"sub" => id}) do
    id
    |> WsprHub.Accounts.get_user()
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims), do: {:error, :not_found}
end
