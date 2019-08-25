defmodule LangDetect do
  @moduledoc """
  Documentation for LangDetect.
  """
  def corpus_dir do
    "./corpus"
  end

  def corpus do
    import SweetXml

    corpus_dir()
    |> Path.join(["index.xml"])
    |> File.read!()
    |> xpath(~x"//udhrs/udhr"l,
      iso639: ~x"./@iso639-3"s,
      script: ~x"./@iso15924"s,
      stage: ~x"./@stage"I,
      name: ~x"./@n"s,
      file: ~x"./@f"s
    )
    |> Enum.map(fn f -> {f[:iso639], Map.delete(f, :iso639)} end)
    |> Enum.filter(fn {_k, v} -> v[:stage] >= 4 end)
    |> Map.new
  end

  def language_codes do
    corpus_dir()
    |> Path.join(["language-codes-3b2.json"])
    |> File.read!()
    |> Jason.decode!
    |> Enum.map(fn l -> {l["alpha3-b"], Map.get(l, "alpha2")} end)
    |> Map.new
  end
end
