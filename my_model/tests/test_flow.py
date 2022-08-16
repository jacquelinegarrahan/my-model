from my_model.flow import flow


def test_flow_execution(tmp_path):
    flow.run(filename=f"{tmp_path}/test_file.txt", filesystem_identifier="local")
