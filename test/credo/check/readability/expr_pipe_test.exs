defmodule Credo.Check.Readability.SinglePipeTest do
  use Credo.Test.Case

  @described_check Credo.Check.Readability.ExprPipe

  #
  # cases NOT raising issues
  #

  test "it should NOT report expected code" do
    """
    defmodule CredoSampleModule do
      use ExUnit.Case

      def some_fun do
        var = some_val
        |> do_something
        |> do_something_else

        case var do
          :this -> :that
          :that -> :this
        end
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  #
  # cases raising issues
  #

  test "it should report a violation for case" do
    """
    defmodule CredoSampleModule do

      def some_fun do
        some_val 
        |> case do 
          :this -> :that
          :that -> :this
        end
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report a violation for if" do
    """
    defmodule CredoSampleModule do

      def some_fun do
        some_val 
        |> if do 
            :this
          else 
            :that
          end
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report a violation for unless" do
    """
    defmodule CredoSampleModule do

      def some_fun do
        some_val 
        |> unless do 
            :this
          end
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report a violation for multiple violations" do
    """
    defmodule CredoSampleModule do

      def some_fun do
        some_val 
        |> case do
            :this -> :that
            :that -> :this
          end

        some_val 
        |> unless do 
            :this
          end

        some_val
        |> if do 
            :this
           else 
            :that
           end
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issues()
  end
end
