
salt_mine_doc_dirs:
  file.directory:
  - names:
    - /srv/static/extern/salt/source/_static
    - /srv/static/extern/salt/source/services
    - /srv/static/extern/salt/source/nodes
    - /srv/static/extern/salt/source/devices
  - user: root
  - mode: 755
  - makedirs: true

/srv/static/extern/salt/Makefile:
  file.managed:
  - source: salt://sphinx/files/salt/Makefile
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs

/srv/static/extern/salt/source/conf.py:
  file.managed:
  - source: salt://sphinx/files/salt/source/conf.py
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc: {{ doc|yaml }}

/srv/static/extern/salt/source/index.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/index.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc_name: "{{ doc_name }}"

/srv/static/extern/salt/source/services/index.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/services/index.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc_name: "{{ doc_name }}"

/srv/static/extern/salt/source/services/monitoring.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/services/monitoring.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc_name: "{{ doc_name }}"

/srv/static/extern/salt/source/services/endpoints.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/services/endpoints.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc_name: "{{ doc_name }}"

/srv/static/extern/salt/source/services/catalog.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/services/catalog.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc_name: "{{ doc_name }}"

/srv/static/extern/salt/source/nodes/index.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/nodes/index.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      doc_name: "{{ doc_name }}"

{%- set mine_nodes = salt['mine.get']('*', 'grains.items') %}
{%- if mine_nodes is mapping %}

{%- for node_name, node_grains in mine_nodes.iteritems() %}

/srv/static/extern/salt/source/nodes/{{ node_name }}.rst:
  file.managed:
  - source: salt://sphinx/files/salt/source/nodes/node.rst
  - template: jinja
  - mode: 644
  - require:
    - file: salt_mine_doc_dirs
  - defaults:
      node_name: {{ node_name }}
      node_grains: {{ node_grains|yaml }}

{%- endfor %}

{%- endif %}

generate_sphinx_doc_salt_{{ doc_name }}:
  cmd.run:
  - name: sphinx-build -b {{ doc.builder }} /srv/static/extern/salt/source /srv/static/sites/{{ doc_name }}
  - require:
    - file: /srv/static/sites/{{ doc_name }}
